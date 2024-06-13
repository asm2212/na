import 'package:dartz/dartz.dart';

import '../core/failures.dart';
import '../core/value_objects.dart';
import '../core/value_validators.dart';

class EmailAddress extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;
  const EmailAddress._({required this.value});

  factory EmailAddress({
    required String input,
  }) =>
      EmailAddress._(value: validateEmailAddress(input));
}

class Password extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;
  const Password._({required this.value});

  factory Password({
    required String input,
  }) =>
      Password._(value: validatePassword(input));
}
