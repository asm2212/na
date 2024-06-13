import 'package:kt_dart/kt.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';

import '../../../../../utils/icon_broken.dart';
import '../misc/todo_item_presentation_classes.dart';
import '../../../../../domain/notes/value_objects.dart';
import '../../../../../application/notes/note_form/bloc/note_form_bloc.dart';
import '../../../../../presentation/pages/notes/note_form/misc/build_context_x.dart';

class TodoList extends StatelessWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoteFormBloc, NoteFormState>(
      listenWhen: (previous, current) =>
          previous.note.todos.isFull != current.note.todos.isFull,
      listener: (context, state) {
        if (state.note.todos.isFull) {
          FlushbarHelper.createAction(
            title: 'ℹ  INFO',
            duration: const Duration(seconds: 5),
            message: 'Want longer lists? Activate premium 🤩',
            button: TextButton(
              onPressed: () {},
              child: const Text(
                'BUY NOW',
                style: TextStyle(
                  color: Colors.amber,
                ),
              ),
            ),
          ).show(context);
        }
      },
      child: Consumer(
        builder: (BuildContext context, FormTodos formTodos, Widget? _) {
          return ImplicitlyAnimatedReorderableList<TodoItemPrimitive>(
            shrinkWrap: true,
            removeDuration: const Duration(),
            items: formTodos.value.asList(),
            areItemsTheSame: (oldItem, newItem) => oldItem.id == newItem.id,
            onReorderFinished: (item, from, to, newItems) {
              context.formTodos = newItems.toImmutableList();
              context
                  .read<NoteFormBloc>()
                  .add(NoteFormEvent.todosChanged(context.formTodos));
            },
            itemBuilder: (context, itemAnimation, item, index) {
              return Reorderable(
                  key: ValueKey(item.id),
                  builder: (context, dragAnimation, inDrag) {
                    return ScaleTransition(
                      scale: Tween<double>(begin: 1, end: 0.95)
                          .animate(dragAnimation),
                      child: TodoTile(
                        index: index,
                        elevation: dragAnimation.value,
                      ),
                    );
                  });
            },
          );
        },
      ),
    );
  }
}

class TodoTile extends HookWidget {
  final int index;
  final double elevation;
  const TodoTile({double? elevation, required this.index, Key? key})
      : elevation = elevation ?? 0,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final todo =
        context.formTodos.getOrElse(index, (_) => TodoItemPrimitive.empty());
    final textEditingController = useTextEditingController(text: todo.name);
    return Slidable(
      startActionPane: ActionPane(
        extentRatio: 0.35,
        motion: const ScrollMotion(),
        children: <Widget>[
          SlidableAction(
            flex: 1,
            borderRadius: BorderRadius.circular(8),
            backgroundColor: Colors.red[800]!,
            foregroundColor: Colors.white,
            icon: IconBroken.Delete,
            label: 'Delete',
            onPressed: (_) {
              context.formTodos = context.formTodos.minusElement(todo);
              context.read<NoteFormBloc>().add(
                    NoteFormEvent.todosChanged(context.formTodos),
                  );
            },
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
        child: Material(
          borderRadius: BorderRadius.circular(8),
          elevation: elevation == 0 ? 4 : elevation,
          animationDuration: const Duration(milliseconds: 500),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              horizontalTitleGap: 5.0,
              contentPadding: const EdgeInsets.only(left: 10),
              leading: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => ScaleTransition(
                    scale: animation,
                    child: child,
                  ),
                  child: Checkbox(
                    key: ValueKey(todo.done),
                    value: todo.done,
                    onChanged: (value) {
                      context.formTodos = context.formTodos.map(
                        (listTodo) => listTodo == todo
                            ? todo.copyWith(done: value!)
                            : listTodo,
                      );
                      context
                          .read<NoteFormBloc>()
                          .add(NoteFormEvent.todosChanged(context.formTodos));
                    },
                    activeColor: Theme.of(context).colorScheme.secondary,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
              title: TextFormField(
                controller: textEditingController,
                maxLength: TodoName.maxLength,
                style: Theme.of(context).textTheme.subtitle1,
                decoration: const InputDecoration(
                  hintText: 'Todo',
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  counterText: '',
                ),
                onChanged: (value) {
                  context.formTodos = context.formTodos.map(
                    (listTodo) => listTodo == todo
                        ? todo.copyWith(name: value)
                        : listTodo,
                  );
                  context
                      .read<NoteFormBloc>()
                      .add(NoteFormEvent.todosChanged(context.formTodos));
                },
                validator: (_) => context
                    .read<NoteFormBloc>()
                    .state
                    .note
                    .todos
                    .value
                    // Failure stemming from the TodoList length should NOT be displayed by the individual TextFormFields
                    .fold(
                      (failure) => null,
                      (todoList) => todoList[index].name.value.fold(
                            (failure) => failure.maybeWhen(
                              exceedingLength: (_, len) =>
                                  'Too long, max: $len',
                              empty: (_) => 'Cannot be empty',
                              multiline: (_) => 'Has to be in a single line',
                              orElse: () => null,
                            ),
                            (right) => null,
                          ),
                    ),
              ),
              trailing: const Handle(
                child: Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Icon(IconBroken.Swap),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
