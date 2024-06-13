import 'package:kt_dart/kt.dart';
import 'package:dartz/dartz.dart';

import '../../../utils/constants.dart';
import '../../domain/core/failures.dart';

/// for validate Email Address.
Either<ValueFailure<String>, String> validateEmailAddress(String input) {
  if (regExpEmail.hasMatch(input)) {
    return right(input);
  } else {
    return left(
      ValueFailure.invalidEmail(
        failedValue: input,
      ),
    );
  }
}

/// for validate password
Either<ValueFailure<String>, String> validatePassword(String input) {
  if (regExpPass.hasMatch(input)) {
    return right(input);
  } else {
    return left(
      ValueFailure.shortPassword(
        failedValue: input,
      ),
    );
  }
}

/// for validate character length of notes
Either<ValueFailure<String>, String> validateMaxStringLength(
  String input,
  int maxLength,
) {
  if (input.length <= maxLength) {
    return right(input);
  } else {
    return left(
      ValueFailure.exceedingLength(
        failedValue: input,
        max: maxLength,
      ),
    );
  }
}

/// for validate notes is not empty
Either<ValueFailure<String>, String> validateStringNotEmpty(
  String input,
) {
  if (input.isNotEmpty) {
    return right(input);
  } else {
    return left(
      ValueFailure.empty(
        failedValue: input,
      ),
    );
  }
}

/// for validate the number of lines used to label a name of todo list
Either<ValueFailure<String>, String> validateSingleLine(
  String input,
) {
  if (!input.contains('\n')) {
    return right(input);
  } else {
    return left(
      ValueFailure.multiline(
        failedValue: input,
      ),
    );
  }
}

/// for validate length of todo list
Either<ValueFailure<KtList<T>>, KtList<T>> validateMaxListLength<T>(
  KtList<T> input,
  int maxLength,
) {
  if (input.size <= maxLength) {
    return right(input);
  } else {
    return left(
      ValueFailure.listTooLong(
        failedValue: input,
        max: maxLength,
      ),
    );
  }
}
