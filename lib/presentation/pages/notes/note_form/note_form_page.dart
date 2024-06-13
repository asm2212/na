import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:another_flushbar/flushbar_helper.dart';

import '../../../../injection.dart';
import '../../../routes/router.gr.dart';
import './widgets/todo_list_widget.dart';
import './widgets/body_field_widget.dart';
import './widgets/color_field_widget.dart';
import '../../../../domain/notes/note.dart';
import './widgets/add_todo_tile_widget.dart';
import './misc/todo_item_presentation_classes.dart';
import '../../../../application/notes/note_form/bloc/note_form_bloc.dart';

class NoteFormPage extends StatelessWidget {
  final Note? editedNote;
  const NoteFormPage({Key? key, required this.editedNote}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NoteFormBloc>()
        ..add(
          NoteFormEvent.initialized(
            optionOf(editedNote),
          ),
        ),
      child: BlocConsumer<NoteFormBloc, NoteFormState>(
        listenWhen: (previous, current) =>
            previous.saveFailureOrSuccessOption !=
            current.saveFailureOrSuccessOption,
        listener: (context, state) {
          state.saveFailureOrSuccessOption.fold(
            () {}, // none
            (either) => either.fold(
              // some failure or success option
              (failure) {
                FlushbarHelper.createError(
                  title: '⚠ ERROR',
                  duration: const Duration(seconds: 5),
                  message: failure.when(
                    unexpected: () =>
                        "Unexpected error occurred while deleting, please contact support. 👨‍💻",
                    insufficientPermissions: () => "Insufficient permissions ❌",
                    unableToUpdate: () => "Impossible error 😵",
                  ),
                ).show(context);
              },

              /// because flushbar(snackbar) is treated like route
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
            SavingInProgressOverlay(
              isSaving: state.isSaving,
            ),
          ],
        ),
      ),
    );
  }
}

class SavingInProgressOverlay extends StatelessWidget {
  final bool isSaving;
  const SavingInProgressOverlay({
    Key? key,
    required this.isSaving,
  }) : super(key: key);

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
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    'Saving',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.white),
                  ),
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
          buildWhen: (previous, current) =>
              previous.isEditing != current.isEditing,
          builder: (context, state) {
            return Text(state.isEditing
                ? 'Edit your note 👨‍🏫'
                : 'Create new note 💪');
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => context.read<NoteFormBloc>().add(
                  const NoteFormEvent.saved(),
                ),
          ),
        ],
      ),
      body: BlocBuilder<NoteFormBloc, NoteFormState>(
        buildWhen: (previous, current) =>
            previous.showErrorMessages != current.showErrorMessages,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChangeNotifierProvider<FormTodos>(
              create: (context) => FormTodos(),
              child: Form(
                autovalidateMode: state.showErrorMessages
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                child: SingleChildScrollView(
                    child: Column(
                  children: const [
                    SizedBox(height: 9),
                    BodyField(),
                    ColorField(),
                    TodoList(),
                    AddTodoTile(),
                  ],
                )),
              ),
            ),
          );
        },
      ),
    );
  }
}
