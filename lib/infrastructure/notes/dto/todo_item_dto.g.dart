// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TodoItemDto _$$_TodoItemDtoFromJson(Map<String, dynamic> json) =>
    _$_TodoItemDto(
      id: json['id'] as String,
      name: json['name'] as String,
      done: json['done'] as bool,
    );

Map<String, dynamic> _$$_TodoItemDtoToJson(_$_TodoItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'done': instance.done,
    };
