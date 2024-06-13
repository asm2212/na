import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/notes/note.dart';
import '../../../domain/notes/note_failure.dart';
import '../../../domain/notes/i_note_repository.dart';

part 'note_actor_event.dart';
part 'note_actor_state.dart';
part 'note_actor_bloc.freezed.dart';

@injectable
class NoteActorBloc extends Bloc<NoteActorEvent, NoteActorState> {
  final INoteRepository _noteRepository;
  NoteActorBloc(this._noteRepository) : super(const Initial()) {
    on<NoteActorEvent>((event, emit) async {
      // We have only one NoteActorEvent - there's no union type
      if (event is Deleted) {
        emit(const NoteActorState.actionInProgress());
        final failureOrSuccess = await _noteRepository.delete(event.note);
        emit(
          failureOrSuccess.fold(
            (failure) => NoteActorState.deleteFailure(failure),
            (_) => const NoteActorState.deleteSuccess(),
          ),
        );
      }
    });
  }
}
