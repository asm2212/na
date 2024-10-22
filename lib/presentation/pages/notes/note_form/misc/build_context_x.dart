import 'package:kt_dart/Kt.dart';
import 'package:flutter/Widgets.dart';
import 'package:na/presentation/pages/notes/note_form/misc/todo_item_presentation_classes.dart';
import 'package:provider/provider.dart';

extension FormTodosX on BuildContext {
  KtList<TodoItemPrimitive> get formTodos =>
      Provider.of<FormTodos>(this, listen: false).value;
  set formTodos(KtList<TodoItemPrimitive> value) =>
      Provider.of<FormTodos>(this, listen: false).value = value;
}
