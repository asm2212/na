import 'package:dartz/dartz.dart';
import 'package:kt_dart/collection.dart';

import '../../domain/notes/note.dart';
import '../../domain/notes/note_failure.dart';

abstract class INoteRepository {
  // Reads all the notes
  Stream<Either<NoteFailure, KtList<Note>>> watchAll();
  // Read uncompleted notes
  Stream<Either<NoteFailure, KtList<Note>>> watchUncompleted();
  // Create a new Note Document
  Future<Either<NoteFailure, Unit>> create(Note note);
  // Update the Note Document
  Future<Either<NoteFailure, Unit>> update(Note note);
  // Delete the Note Document
  Future<Either<NoteFailure, Unit>> delete(Note note);
}
