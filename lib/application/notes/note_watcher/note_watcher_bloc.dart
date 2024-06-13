import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:kt_dart/kt.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/notes/note.dart';
import '../../../domain/notes/note_failure.dart';
import '../../../domain/notes/i_note_repository.dart';

part 'note_watcher_event.dart';
part 'note_watcher_state.dart';
part 'note_watcher_bloc.freezed.dart';

@injectable
class NoteWatcherBloc extends Bloc<NoteWatcherEvent, NoteWatcherState> {
  final INoteRepository _noteRepository;
  StreamSubscription<Either<NoteFailure, KtList<Note>>>?
      _noteStreamSubscription;

  NoteWatcherBloc(this._noteRepository) : super(const Initial()) {
    on<NoteWatcherEvent>((event, emit) async {
      await event.when(watchAllStarted: () async {
        emit(const NoteWatcherState.loadInProgress());
        await _noteStreamSubscription?.cancel();
        _noteStreamSubscription =
            _noteRepository.watchAll().listen((failureOrNotes) {
          add(
            NoteWatcherEvent.notesReceived(
                failureOrNotes), // We add event here to solve yield* problem
          );
        });
      }, watchUncompletedStarted: () async {
        emit(const NoteWatcherState.loadInProgress());
        await _noteStreamSubscription?.cancel();
        _noteStreamSubscription =
            _noteRepository.watchUncompleted().listen((failureOrNotes) {
          add(
            NoteWatcherEvent.notesReceived(
                failureOrNotes), // We add event here to solve yield* problem
          );
        });
      }, notesReceived: (failureOrNotes) {
        emit(
          failureOrNotes.fold(
            (failure) => NoteWatcherState.loadFailure(failure),
            (notes) => NoteWatcherState.loadSuccess(notes),
          ),
        );
      });
    });
  }

  @override
  Future<void> close() async {
    await _noteStreamSubscription!.cancel();
    return super.close();
  }
}
