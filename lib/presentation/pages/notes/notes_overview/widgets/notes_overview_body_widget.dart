import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:na/application/notes/note_watcher/note_watcher_bloc.dart';
import 'package:na/domain/notes/note.dart';
import 'package:na/presentation/pages/notes/notes_overview/widgets/critical_failure_display_widget.dart';
import 'package:na/presentation/pages/notes/notes_overview/widgets/error_note_card_widget.dart';
import 'package:na/presentation/pages/notes/notes_overview/widgets/note_card_widget.dart';
class NotesOverviewBody extends StatelessWidget {
  const NotesOverviewBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteWatcherBloc, NoteWatcherState>(
      builder: (context, state) {
        return state.when(
          initial: () => const Offstage(),
          loadInProgress: () =>
              const Center(child: CircularProgressIndicator()),
          loadSuccess: (notes) => ListView.builder(
              itemCount: notes.size,
              itemBuilder: (context, index) {
                final note = notes[index];
                if (note.failureOption.isSome()) {
                  return ErrorNoteCard(note: note);
                }
                return NoteCard(note: note);
              }),
          loadFailure: (failure) => CriticalFailureDisplay(
            failure: failure,
          ),
        );
      },
    );
  }
}
