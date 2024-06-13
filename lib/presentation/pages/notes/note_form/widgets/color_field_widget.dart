import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../domain/notes/value_objects.dart';
import '../../../../../application/notes/note_form/bloc/note_form_bloc.dart';

class ColorField extends StatelessWidget {
  const ColorField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteFormBloc, NoteFormState>(
      buildWhen: (previous, current) =>
          previous.note.color != current.note.color,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final itemColor = NoteColor.predefinedColors[index];
                return GestureDetector(
                  onTap: () => context
                      .read<NoteFormBloc>()
                      .add(NoteFormEvent.colorChanged(itemColor)),
                  child: Material(
                    color: itemColor,
                    elevation: 6,
                    shape: CircleBorder(
                      side: state.note.color.value.fold(
                        (failure) => BorderSide.none,
                        (color) => color == itemColor
                            ? const BorderSide(width: 1.2)
                            : BorderSide.none,
                      ),
                    ),
                    child: Container(
                      height: 62,
                      width: 62,
                      decoration: const BoxDecoration(),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                width: 13,
              ),
              itemCount: NoteColor.predefinedColors.length,
            ),
          ),
        );
      },
    );
  }
}
