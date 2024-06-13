import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../domain/notes/value_objects.dart';
import '../../../../../application/notes/note_form/bloc/note_form_bloc.dart';

class BodyField extends HookWidget {
  const BodyField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textEditingController = useTextEditingController();
    return BlocListener<NoteFormBloc, NoteFormState>(
      listenWhen: (previous, current) =>
          previous.isEditing != current.isEditing,
      listener: (context, state) {
        textEditingController.text = state.note.body.getOrCrash();
      },
      child: TextFormField(
        controller: textEditingController,
        decoration: const InputDecoration(
          labelText: 'Note',
          hintText: 'what\'s in your mind ?',
          alignLabelWithHint: true,
          // counterText: '',
          counterStyle: TextStyle(color: Colors.black),
        ),
        minLines: 6,
        maxLines: null,
        autocorrect: false,
        maxLength: NoteBody.maxLength,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        style: Theme.of(context).textTheme.headline4,
        onChanged: (value) =>
            context.read<NoteFormBloc>().add(NoteFormEvent.bodyChanged(value)),
        validator: (_) => context
            .read<NoteFormBloc>()
            .state
            .note
            .body
            .value
            .fold(
              (failure) => failure.maybeWhen(
                  exceedingLength: (_, len) => 'Exceeding length, max: $len',
                  empty: (_) => 'Cannot be empty Note',
                  orElse: () => null),
              (right) => null,
            ),
      ),
    );
  }
}
