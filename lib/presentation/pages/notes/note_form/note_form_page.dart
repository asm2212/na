
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:na/application/notes/note_form/bloc/note_form_bloc.dart';
import 'package:na/domain/notes/note.dart';
import 'package:na/injection.dart';
import 'package:na/presentation/pages/notes/note_form/misc/todo_item_presentation_classes.dart';
import 'package:na/presentation/pages/notes/note_form/widgets/add_todo_tile_widget.dart';
import 'package:na/presentation/pages/notes/note_form/widgets/body_field_widget.dart';
import 'package:na/presentation/pages/notes/note_form/widgets/color_field_widget.dart';
import 'package:na/presentation/pages/notes/note_form/widgets/todo_list_widget.dart';
import 'package:na/presentation/routes/router.gr.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';

class NoteFormPage extends StatelessWidget {
  final Note? editedNote;

  const NoteFormPage({Key? key, required this.editedNote}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NoteFormBloc>()
        ..add(NoteFormEvent.initialized(optionOf(editedNote))),
      child: BlocConsumer<NoteFormBloc, NoteFormState>(
        listenWhen: (previous, current) =>
            previous.saveFailureOrSuccessOption != current.saveFailureOrSuccessOption,
        listener: (context, state) {
          state.saveFailureOrSuccessOption.fold(
            () {}, // none
            (either) => either.fold(
              // some failure or success option
              (failure) {
                FlushbarHelper.createError(
                  title: '⚠ ERROR',
                  duration: const Duration(seconds: 5),
                  message: failure.map(
                    unexpected: (_) => "Unexpected error occurred while deleting, please contact support. 👨‍💻",
                    insufficientPermissions: (_) => "Insufficient permissions ❌",
                    unableToUpdate: (_) => "Impossible error 😵",
                  ),
                ).show(context);
              },
              (_) => context.router.popUntil(
                (route) => route.settings.name == NotesOverviewPageRoute.name,
              ),
            ),
          );
        },
        buildWhen: (previous, current) => previous.isSaving != current.isSaving,
        builder: (context, state) => Stack(
          children: [
            const NoteFormPageScaffold(),
            SavingInProgressOverlay(isSaving: state.isSaving),
          ],
        ),
      ),
    );
  }
}

class SavingInProgressOverlay extends StatelessWidget {
  final bool isSaving;

  const SavingInProgressOverlay({Key? key, required this.isSaving}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isSaving,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: isSaving ? Colors.black.withOpacity(0.7) : Colors.transparent,
        child: Visibility(
          visible: isSaving,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Colors.green[600],
                  backgroundColor: Colors.blue[600],
                ),
                const SizedBox(height: 8),
                Text(
                  'Saving',
                  style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NoteFormPageScaffold extends StatelessWidget {
  const NoteFormPageScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<NoteFormBloc, NoteFormState>(
          buildWhen: (previous, current) => previous.isEditing != current.isEditing,
          builder: (context, state) {
            return Text(state.isEditing ? 'Edit your note 👨‍🏫' : 'Create new note 💪');
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => context.read<NoteFormBloc>().add(const NoteFormEvent.saved()),
          ),
        ],
      ),
      body: BlocBuilder<NoteFormBloc, NoteFormState>(
        buildWhen: (previous, current) => previous.showErrorMessages != current.showErrorMessages,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChangeNotifierProvider(
              create: (_) => FormTodos(),
              child: Form(
                autovalidateMode: state.showErrorMessages ? AutovalidateMode.always : AutovalidateMode.disabled,
                child: SingleChildScrollView(
                  child: Column(
                    children: const [
                      SizedBox(height: 9),
                      BodyField(),
                      ColorField(),
                      TodoList(),
                      AddTodoTile(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}