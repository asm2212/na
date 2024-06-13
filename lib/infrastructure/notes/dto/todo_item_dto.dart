import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/notes/todo_item.dart';
import '../../../domain/core/value_objects.dart';
import '../../../domain/notes/value_objects.dart';

part 'todo_item_dto.g.dart';
part 'todo_item_dto.freezed.dart';

@freezed
abstract class TodoItemDto implements _$TodoItemDto {
  const TodoItemDto._();

  const factory TodoItemDto({
    required String id,
    required String name,
    required bool done,
  }) = _TodoItemDto;

  factory TodoItemDto.fromDomain(TodoItem todoItem) {
    return TodoItemDto(
      id: todoItem.id.getOrCrash(),
      name: todoItem.name.getOrCrash(),
      done: todoItem.done,
    );
  }

  TodoItem toDomain() {
    return TodoItem(
      id: UniqueId.fromUniqueString(uniqueIdStr: id),
      name: TodoName(input: name),
      done: done,
    );
  }

  factory TodoItemDto.fromJson(Map<String, dynamic> json) =>
      _$TodoItemDtoFromJson(json);
}


/// for build runner: flutter pub run build_runner watch --delete-conflicting-outputs
