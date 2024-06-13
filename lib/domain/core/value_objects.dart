import 'package:uuid/uuid.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

import './failures.dart';
import '../core/errors.dart';

@immutable
abstract class ValueObject<T> extends Equatable {
  const ValueObject();

  Either<ValueFailure<T>, T> get value;

  bool get isValid => value.isRight();

  /// Throws [UnexpectedValueError] containing the [ValueFailure]
  T getOrCrash() {
    // id = identity - same as writing for right side: (str) => str
    return value.fold((failure) => throw UnexpectedValueError(failure), id);
  }

  Either<ValueFailure<dynamic>, Unit> get failureOrUnit {
    return value.fold(
      (l) => left(l),
      (r) => right(unit),
    );
  }

  @override
  List<Object?> get props => [value];

  @override
  String toString() => 'Value($value)';
}

class UniqueId extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;
  const UniqueId._(this.value);

  // We cannot let a simple String be passed in. This would allow for possible non-unique IDs.
  // Used with IDs for Notes
  factory UniqueId() {
    return UniqueId._(
      right(const Uuid().v1()),
    );
  }

  /// Used with strings we trust are unique, such as database IDs and IDs from Firebase
  factory UniqueId.fromUniqueString({required String uniqueIdStr}) {
    return UniqueId._(
      right(uniqueIdStr),
    );
  }
}
