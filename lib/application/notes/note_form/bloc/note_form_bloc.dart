import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:kt_dart/kt.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/notes/note.dart';
import '../../../../domain/notes/note_failure.dart';
import '../../../../domain/notes/value_objects.dart';
import '../../../../domain/notes/i_note_repository.dart';
import '../../../../presentation/pages/notes/note_form/misc/todo_item_presentation_classes.dart';

part 'note_form_event.dart';
part 'note_form_state.dart';
part 'note_form_bloc.freezed.dart';

@injectable
class NoteFormBloc extends Bloc<NoteFormEvent, NoteFormState> {
  final INoteRepository _noteRepository;

  NoteFormBloc(this._noteRepository) : super(NoteFormState.initial()) {
    on<NoteFormEvent>((event, emit) async {
      await event.when(
        initialized: (initialNoteOption) {
          emit(
            initialNoteOption.fold(
              // is none - Yielding an unchanged state results in not emitting anything at all
              () => state,
              // is some
              (initialNote) => state.copyWith(
                note: initialNote,
                isEditing: true,
              ),
            ),
          );
        },
        bodyChanged: (bodyStr) {
          emit(
            state.copyWith(
              note: state.note.copyWith(
                body: NoteBody(input: bodyStr),
              ),
              saveFailureOrSuccessOption: none(),
            ),
          );
        },
        colorChanged: (color) {
          emit(
            state.copyWith(
              note: state.note.copyWith(
                color: NoteColor(input: color),
              ),
              saveFailureOrSuccessOption: none(),
            ),
          );
        },
        todosChanged: (todos) {
          emit(
            state.copyWith(
              note: state.note.copyWith(
                todos: List3(
                  input: todos.map(
                    (primitive) => primitive.toDomain(),
                  ),
                ),
              ),
              saveFailureOrSuccessOption: none(),
            ),
          );
        },
        saved: () async {
          Either<NoteFailure, Unit>? failureOrSuccess;

          emit(
            state.copyWith(
              isSaving: true,
              saveFailureOrSuccessOption: none(),
            ),
          );

          if (state.note.failureOption.isNone()) {
            failureOrSuccess = state.isEditing
                ? await _noteRepository.update(state.note)
                : await _noteRepository.create(state.note);
          }

          emit(
            state.copyWith(
              isSaving: false,
              showErrorMessages: true,
              saveFailureOrSuccessOption: optionOf(failureOrSuccess),
            ),
          );
        },
      );
    });
  }
}
