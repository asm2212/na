import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:na/application/notes/note_watcher/note_watcher_bloc.dart';
import 'package:na/utils/icon_broken.dart';


enum FilterOptions {
  allNotes,
  uncompleted,
}

class UncompletedSwitch extends HookWidget {
  const UncompletedSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final toggleState = useState<bool>(true);
    return Padding(
      padding: const EdgeInsets.only(right: 3.0),
      child: PopupMenuButton(
        onSelected: (FilterOptions selectedValue) {
          if (selectedValue == FilterOptions.allNotes) {
            toggleState.value = true;
            context
                .read<NoteWatcherBloc>()
                .add(const NoteWatcherEvent.watchAllStarted());
          } else {
            toggleState.value = false;
            context
                .read<NoteWatcherBloc>()
                .add(const NoteWatcherEvent.watchUncompletedStarted());
          }
        },
        icon: const Icon(IconBroken.More_Circle),
        itemBuilder: (_) => [
          const PopupMenuItem(
            padding: EdgeInsets.symmetric(horizontal: 2.0),
            child: Center(
                child: Text(
              'All Notes',
              style: TextStyle(color: Colors.black),
            )),
            value: FilterOptions.allNotes,
          ),
          const PopupMenuItem(
            padding: EdgeInsets.symmetric(horizontal: 2.0),
            child: Center(
                child: Text(
              'Uncompleted',
              style: TextStyle(color: Colors.black),
            )),
            value: FilterOptions.uncompleted,
          ),
        ],
      ),
    );
  }
}
