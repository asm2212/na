import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../core/failures.dart';
import '../core/value_objects.dart';
import '../../domain/notes/value_objects.dart';

part 'todo_item.freezed.dart';

@freezed
class TodoItem with _$TodoItem {
  const factory TodoItem({
    required UniqueId id,
    required TodoName name,
    required bool done,
  }) = _TodoItem;

  factory TodoItem.empty() => TodoItem(
        id: UniqueId(),
        name: TodoName(input: ''),
        done: false,
      );
}

extension TodoItemX on TodoItem {
  Option<ValueFailure<dynamic>> get failureOption {
    return name.failureOrUnit.fold((failure) => some(failure), (_) => none());
  }
}


/// for build runner: flutter pub run build_runner watch --delete-conflicting-outputs