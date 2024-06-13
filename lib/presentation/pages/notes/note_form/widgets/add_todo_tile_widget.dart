
import 'package:kt_dart/kt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:na/application/notes/note_form/bloc/note_form_bloc.dart';
import 'package:na/presentation/pages/notes/note_form/misc/build_context_x.dart';
import 'package:na/presentation/pages/notes/note_form/misc/todo_item_presentation_classes.dart';
import 'package:na/utils/icon_broken.dart';

class AddTodoTile extends StatelessWidget {
  const AddTodoTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteFormBloc, NoteFormState>(
      listenWhen: (previous, current) =>
          previous.isEditing != current.isEditing,
      listener: (context, state) {
        context.formTodos = state.note.todos.value.fold(
          (failure) => listOf<TodoItemPrimitive>(),
          (todoItemList) => todoItemList.map<TodoItemPrimitive>(
              (todoItem) => TodoItemPrimitive.fromDomain(todoItem)),
        );
      },
      buildWhen: (previous, current) =>
          previous.note.todos.isFull != current.note.todos.isFull,
      builder: (context, state) {
        return ListTile(
          enabled: !state.note.todos.isFull,
          horizontalTitleGap: 5.0,
          contentPadding: const EdgeInsets.only(left: 10),
          title: Text(
            'Add a todo  ✍',
            style: !state.note.todos.isFull
                ? Theme.of(context).textTheme.headline6
                : Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.grey),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(
                left: 8.0, right: 10.0, top: 10.0, bottom: 10.0),
            child: Icon(
              IconBroken.Plus,
              color: !state.note.todos.isFull ? Colors.black : Colors.grey,
            ),
          ),
          onTap: () {
            context.formTodos =
                context.formTodos.plusElement(TodoItemPrimitive.empty());
            context
                .read<NoteFormBloc>()
                .add(NoteFormEvent.todosChanged(context.formTodos));
          },
        );
      },
    );
  }
}