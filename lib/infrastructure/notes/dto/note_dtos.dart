import 'dart:ui';

import 'package:kt_dart/kt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import './todo_item_dto.dart';
import '../../../domain/notes/note.dart';
import '../../../domain/core/value_objects.dart';
import '../../../domain/notes/value_objects.dart';

part 'note_dtos.g.dart';
part 'note_dtos.freezed.dart';

/// FieldValue type is not supported out-of-the-box. So you should customize the encoding/decoding this type when want generate to/from JSON code
@freezed
abstract class NoteDto implements _$NoteDto {
  const NoteDto._();

  @JsonSerializable(explicitToJson: true)
  factory NoteDto({
    @JsonKey(ignore: true) String? id,
    required String body,
    required int color,
    required List<TodoItemDto> todos,
    @ServerTimestampConverter() required FieldValue serverTimeStamp,
  }) = _NoteDto;

  factory NoteDto.fromDomain(Note note) {
    return NoteDto(
      id: note.id.getOrCrash(),
      body: note.body.getOrCrash(),
      color: note.color.getOrCrash().value,
      todos: note.todos
          .getOrCrash()
          .map(
            (todoItem) => TodoItemDto.fromDomain(todoItem),
          )
          .asList(),
      serverTimeStamp: FieldValue.serverTimestamp(),
    );
  }

  Note toDomain() {
    return Note(
      id: UniqueId.fromUniqueString(uniqueIdStr: id ?? ''),
      body: NoteBody(input: body),
      color: NoteColor(input: Color(color)),
      todos: List3(
        input: todos
            .map(
              (todoItemDto) => todoItemDto.toDomain(),
            )
            .toImmutableList(),
      ),
    );
  }

  factory NoteDto.fromJson(Map<String, dynamic> json) =>
      _$NoteDtoFromJson(json);

  factory NoteDto.fromFirestore(DocumentSnapshot doc) {
    return NoteDto.fromJson(doc.data() as Map<String, dynamic>)
        .copyWith(id: doc.id);
  }
}

class ServerTimestampConverter implements JsonConverter<FieldValue, Object> {
  const ServerTimestampConverter();

  @override
  FieldValue fromJson(Object json) {
    return FieldValue.serverTimestamp();
  }

  @override
  Object toJson(FieldValue fieldValue) => fieldValue;
}


/// for build runner: flutter pub run build_runner watch --delete-conflicting-outputs