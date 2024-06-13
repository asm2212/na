import 'package:kt_dart/kt.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import './todo_item.dart';
import '../core/failures.dart';
import '../core/value_objects.dart';
import '../../domain/notes/todo_item.dart';
import '../../domain/notes/value_objects.dart';
part 'note.freezed.dart';

@freezed
class Note with _$Note {
  const factory Note({
    required UniqueId id,
    required NoteBody body,
    required NoteColor color,
    required List3<TodoItem> todos,
  }) = _Note;

  factory Note.empty() => Note(
        id: UniqueId(),
        body: NoteBody(input: ''),
        color: NoteColor(input: NoteColor.predefinedColors[0]),
        todos: List3(input: emptyList()),
      );
}

extension NoteX on Note {
  Option<ValueFailure<dynamic>> get failureOption {
    return body.failureOrUnit
        .andThen(color.failureOrUnit)
        .andThen(todos.failureOrUnit)
        .andThen(
          todos
              .getOrCrash()
              // Getting the failureOption from the TodoItem ENTITY - NOT a failureOrUnit from a VALUE OBJECT
              .map((todoItem) => todoItem.failureOption)
              .filter((o) => o.isSome())
              // If e can't get the element, the list is empty. In such a case, it's valid.
              .getOrElse(0, (_) => none())
              .fold(() => right(unit), (failure) => left(failure)),
        )
        .fold((failure) => some(failure), (_) => none());
  }
}

/// for build runner: flutter pub run build_runner watch --delete-conflicting-outputs