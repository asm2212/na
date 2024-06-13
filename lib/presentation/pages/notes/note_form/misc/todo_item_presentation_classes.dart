import 'package:kt_dart/kt.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../domain/notes/todo_item.dart';
import '../../../../../domain/core/value_objects.dart';
import '../../../../../domain/notes/value_objects.dart';
part 'todo_item_presentation_classes.freezed.dart';

class FormTodos extends ValueNotifier<KtList<TodoItemPrimitive>> {
  FormTodos() : super(emptyList<TodoItemPrimitive>());
}

@freezed
abstract class TodoItemPrimitive implements _$TodoItemPrimitive {
  const TodoItemPrimitive._();
  const factory TodoItemPrimitive({
    required UniqueId id,
    required String name,
    required bool done,
  }) = _TodoItemPrimitive;

  factory TodoItemPrimitive.empty() => TodoItemPrimitive(
        id: UniqueId(),
        name: '',
        done: false,
      );

  factory TodoItemPrimitive.fromDomain(TodoItem todoItem) {
    return TodoItemPrimitive(
      id: todoItem.id,
      // If we somehow get to this point, we missed something in other parts of the UI. It's better to throw an Error.
      name: todoItem.name.getOrCrash(),
      done: todoItem.done,
    );
  }

  TodoItem toDomain() {
    return TodoItem(
      id: id,
      name: TodoName(input: name),
      done: done,
    );
  }
}
