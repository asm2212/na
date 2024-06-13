import 'package:kt_dart/kt.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import './pop_up_menu_tap.dart';
import '../../../../routes/router.gr.dart';
import '../../../../../utils/extensions.dart';
import '../../../../../domain/notes/note.dart';
import '../../../../../domain/notes/todo_item.dart';
import '../../../../../application/notes/note_actor/note_actor_bloc.dart';

class NoteCard extends HookWidget {
  final Note note;
  const NoteCard({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final toggleState = useState<bool>(false);
    return GestureDetector(
      onTap: () {
        context.router.push(
          NoteFormPageRoute(editedNote: note),
        );
      },
      onLongPressStart: (LongPressStartDetails details) async {
        toggleState.value = true;
        double dx = details.globalPosition.dx;
        double dy = details.globalPosition.dy;
        final result = await showMenu(
            context: context,
            position: RelativeRect.fromLTRB(
                dx, dy, context.width - dx, context.height - dy),
            items: [
              MyPopupMenuItem(
                onClick: () {
                  toggleState.value = false;
                  context.router.push(
                    NoteFormPageRoute(editedNote: note),
                  );
                },
                child: const Text(
                  'Open note',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              MyPopupMenuItem(
                onClick: () {
                  toggleState.value = false;
                  context
                      .read<NoteActorBloc>()
                      .add(NoteActorEvent.deleted(note));
                },
                child: const Text(
                  'Delete note',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ]);
        if (result == null) {
          toggleState.value = false;
        }
      },
      child: Card(
        shape: toggleState.value
            ? const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
                side: BorderSide(color: Colors.black),
              )
            : null,
        color: note.color.getOrCrash(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.body.getOrCrash(),
                style: Theme.of(context).textTheme.headline4,
              ),
              if (note.todos.length > 0) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  children: [
                    ...note.todos
                        .getOrCrash()
                        .map((todo) => TodoDisplay(
                              todoItem: todo,
                            ))
                        .iter
                  ],
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class TodoDisplay extends StatelessWidget {
  final TodoItem todoItem;
  const TodoDisplay({
    Key? key,
    required this.todoItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          todoItem.done ? Icons.check_box : Icons.check_box_outline_blank,
          color: todoItem.done
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).disabledColor,
        ),
        // if (todoItem.done)
        //   Icon(
        //     Icons.check_box,
        //     color: Theme.of(context).colorScheme.secondary,
        //   ),
        // if (!todoItem.done)
        //   Icon(
        //     Icons.check_box_outline_blank,
        //     color: Theme.of(context).disabledColor,
        //   ),

        Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: Text(
            todoItem.name.getOrCrash(),
            style: Theme.of(context).textTheme.subtitle1,
          ),
        )
      ],
    );
  }
}
