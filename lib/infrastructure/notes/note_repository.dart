import 'package:kt_dart/kt.dart';
import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart';
import 'package:injectable/injectable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/notes/note.dart';
import '../../domain/notes/todo_item.dart';
import '../../domain/notes/note_failure.dart';
import '../../domain/notes/i_note_repository.dart';
import '../../infrastructure/notes/dto/note_dtos.dart';
import '../../infrastructure/core/firestore_helpers.dart';

@LazySingleton(as: INoteRepository)
class NoteRepository implements INoteRepository {
  final FirebaseFirestore _firebaseFirestore;

  NoteRepository(this._firebaseFirestore);

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchAll() async* {
    final userDoc = _firebaseFirestore.userDocument();
    yield* userDoc.noteCollection
        .orderBy('serverTimeStamp', descending: true)
        .snapshots()
        .map((snapshot) {
      final docs = snapshot.docs.where((doc) => !doc.metadata.hasPendingWrites);
      return right<NoteFailure, KtList<Note>>(
        docs
            .map((doc) => NoteDto.fromFirestore(doc).toDomain())
            .toImmutableList(),
      );
    }).onErrorReturnWith((ex, _) {
      if (ex is FirebaseException &&
          ex.message!.contains("PERMISSION_DENIED")) {
        return left(const NoteFailure.insufficientPermissions());
      } else {
        // log.error(e.toString) to log unexpected errors everywhere
        return left(const NoteFailure.unexpected());
      }
    });
  }

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchUncompleted() async* {
    final userDoc = _firebaseFirestore.userDocument();
    yield* userDoc.noteCollection
        .orderBy('serverTimeStamp', descending: true)
        .snapshots()
        .map((snapshot) {
          final docs =
              snapshot.docs.where((doc) => !doc.metadata.hasPendingWrites);
          return docs.map(
            (doc) => NoteDto.fromFirestore(doc).toDomain(),
          );
        })
        .map(
          (notes) => right<NoteFailure, KtList<Note>>(
            notes
                .where(
                  (note) => note.todos
                      .getOrCrash()
                      .any((TodoItem todoItem) => !todoItem.done),
                )
                .toImmutableList(),
          ),
        )
        .onErrorReturnWith((ex, _) {
          if (ex is FirebaseException &&
              ex.message!.contains("PERMISSION_DENIED")) {
            return left(const NoteFailure.insufficientPermissions());
          } else {
            // log.error(e.toString) to log unexpected errors everywhere
            return left(const NoteFailure.unexpected());
          }
        });
  }

  @override
  Future<Either<NoteFailure, Unit>> create(Note note) async {
    try {
      final noteDto = NoteDto.fromDomain(note);
      final userDoc = _firebaseFirestore.userDocument();
      await userDoc.noteCollection.doc(noteDto.id).set(noteDto.toJson());
      return right(unit);
    } on FirebaseException catch (ex) {
      // These error codes and messages aren't in the documentation AFAIK, experiment in the debugger to find out about them.
      if (ex.message!.contains('PERMISSION_DENIED')) {
        return left(const NoteFailure.insufficientPermissions());
      } else {
        return left(const NoteFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> update(Note note) async {
    try {
      final noteDto = NoteDto.fromDomain(note);
      final userDoc = _firebaseFirestore.userDocument();
      await userDoc.noteCollection.doc(noteDto.id).update(noteDto.toJson());
      return right(unit);
    } on FirebaseException catch (ex) {
      if (ex.message!.contains('PERMISSION_DENIED')) {
        return left(const NoteFailure.insufficientPermissions());
      } else if (ex.message!.contains('NOT_FOUND')) {
        return left(const NoteFailure.unableToUpdate());
      } else {
        return left(const NoteFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> delete(Note note) async {
    try {
      final noteId = note.id.getOrCrash();
      final userDoc = _firebaseFirestore.userDocument();
      await userDoc.noteCollection.doc(noteId).delete();
      return right(unit);
    } on FirebaseException catch (ex) {
      if (ex.message!.contains('PERMISSION_DENIED')) {
        return left(const NoteFailure.insufficientPermissions());
      } else if (ex.message!.contains('NOT_FOUND')) {
        return left(const NoteFailure.unableToUpdate());
      } else {
        return left(const NoteFailure.unexpected());
      }
    }
  }
}
