part of 'note_form_bloc.dart';

@freezed
class NoteFormEvent with _$NoteFormEvent {
  // Note? initialNoteOption
  const factory NoteFormEvent.initialized(Option<Note> initialNoteOption) =
      _Initialized;
  const factory NoteFormEvent.bodyChanged(String bodyStr) = _BodyChanged;
  const factory NoteFormEvent.colorChanged(Color color) = _ColorChanged;
  const factory NoteFormEvent.todosChanged(KtList<TodoItemPrimitive> todos) =
      _TodosChanged;
  const factory NoteFormEvent.saved() = _Saved;
}
