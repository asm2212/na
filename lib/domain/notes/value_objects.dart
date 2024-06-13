import 'dart:ui';

import 'package:kt_dart/kt.dart';
import 'package:dartz/dartz.dart';

import '../core/failures.dart';
import '../core/value_objects.dart';
import '../core/value_validators.dart';
import '../core/value_transformers.dart';

class NoteBody extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;
  static const maxLength = 1000;
  const NoteBody._({required this.value});

  factory NoteBody({
    required String input,
  }) =>
      NoteBody._(
        value: validateMaxStringLength(input, maxLength)
            .flatMap(validateStringNotEmpty),
      );
}

class TodoName extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;
  static const maxLength = 30;
  const TodoName._({required this.value});

  factory TodoName({
    required String input,
  }) =>
      TodoName._(
        value: validateMaxStringLength(input, maxLength)
            .flatMap(validateStringNotEmpty)
            .flatMap(validateSingleLine),
      );
}

class NoteColor extends ValueObject<Color> {
  static const List<Color> predefinedColors = [
    Color(0xfffafafa), // canvas
    Color(0xfffa8072), // salmon
    Color(0xfffedc56), // mustard
    Color(0xffd0f0c0), // tea
    Color(0xfffca3b7), // flamingo
    Color(0xff997950), // tortilla
    Color(0xfffffdd0), // cream
    Color(0xffa13430), //
    Color(0xff669ecd), //
    Color(0xffe0a5d0), //
    Color(0xff89cd5d), //
    Color(0xffffe5b4), //
    Color(0xffb2ba6b), //
    Color(0xffe3711d), //
    Color(0xff53ecbd), //
  ];
  @override
  final Either<ValueFailure<Color>, Color> value;
  const NoteColor._(this.value);

  factory NoteColor({required Color input}) {
    if (predefinedColors.contains(input)) {
      return NoteColor._(right(input));
    } else {
      return NoteColor._(
        right(makeColorOpaque(input)),
      );
    }
  }
}

class List3<T> extends ValueObject<KtList<T>> {
  @override
  final Either<ValueFailure<KtList<T>>, KtList<T>> value;
  static const maxLength = 3;
  const List3._(this.value);

  factory List3({required KtList<T> input}) {
    return List3._(
      validateMaxListLength(input, maxLength),
    );
  }

  int get length {
    return value.getOrElse(() => emptyList()).size;
  }

  bool get isFull {
    return length == maxLength;
  }
}
