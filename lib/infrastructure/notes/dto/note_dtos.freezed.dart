// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'note_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

NoteDto _$NoteDtoFromJson(Map<String, dynamic> json) {
  return _NoteDto.fromJson(json);
}

/// @nodoc
mixin _$NoteDto {
  @JsonKey(ignore: true)
  String? get id => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  int get color => throw _privateConstructorUsedError;
  List<TodoItemDto> get todos => throw _privateConstructorUsedError;
  @ServerTimestampConverter()
  FieldValue get serverTimeStamp => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NoteDtoCopyWith<NoteDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoteDtoCopyWith<$Res> {
  factory $NoteDtoCopyWith(NoteDto value, $Res Function(NoteDto) then) =
      _$NoteDtoCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(ignore: true) String? id,
      String body,
      int color,
      List<TodoItemDto> todos,
      @ServerTimestampConverter() FieldValue serverTimeStamp});
}

/// @nodoc
class _$NoteDtoCopyWithImpl<$Res> implements $NoteDtoCopyWith<$Res> {
  _$NoteDtoCopyWithImpl(this._value, this._then);

  final NoteDto _value;
  // ignore: unused_field
  final $Res Function(NoteDto) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? body = freezed,
    Object? color = freezed,
    Object? todos = freezed,
    Object? serverTimeStamp = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      body: body == freezed
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      color: color == freezed
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
      todos: todos == freezed
          ? _value.todos
          : todos // ignore: cast_nullable_to_non_nullable
              as List<TodoItemDto>,
      serverTimeStamp: serverTimeStamp == freezed
          ? _value.serverTimeStamp
          : serverTimeStamp // ignore: cast_nullable_to_non_nullable
              as FieldValue,
    ));
  }
}

/// @nodoc
abstract class _$$_NoteDtoCopyWith<$Res> implements $NoteDtoCopyWith<$Res> {
  factory _$$_NoteDtoCopyWith(
          _$_NoteDto value, $Res Function(_$_NoteDto) then) =
      __$$_NoteDtoCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(ignore: true) String? id,
      String body,
      int color,
      List<TodoItemDto> todos,
      @ServerTimestampConverter() FieldValue serverTimeStamp});
}

/// @nodoc
class __$$_NoteDtoCopyWithImpl<$Res> extends _$NoteDtoCopyWithImpl<$Res>
    implements _$$_NoteDtoCopyWith<$Res> {
  __$$_NoteDtoCopyWithImpl(_$_NoteDto _value, $Res Function(_$_NoteDto) _then)
      : super(_value, (v) => _then(v as _$_NoteDto));

  @override
  _$_NoteDto get _value => super._value as _$_NoteDto;

  @override
  $Res call({
    Object? id = freezed,
    Object? body = freezed,
    Object? color = freezed,
    Object? todos = freezed,
    Object? serverTimeStamp = freezed,
  }) {
    return _then(_$_NoteDto(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      body: body == freezed
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      color: color == freezed
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
      todos: todos == freezed
          ? _value._todos
          : todos // ignore: cast_nullable_to_non_nullable
              as List<TodoItemDto>,
      serverTimeStamp: serverTimeStamp == freezed
          ? _value.serverTimeStamp
          : serverTimeStamp // ignore: cast_nullable_to_non_nullable
              as FieldValue,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_NoteDto extends _NoteDto {
  _$_NoteDto(
      {@JsonKey(ignore: true) this.id,
      required this.body,
      required this.color,
      required final List<TodoItemDto> todos,
      @ServerTimestampConverter() required this.serverTimeStamp})
      : _todos = todos,
        super._();

  factory _$_NoteDto.fromJson(Map<String, dynamic> json) =>
      _$$_NoteDtoFromJson(json);

  @override
  @JsonKey(ignore: true)
  final String? id;
  @override
  final String body;
  @override
  final int color;
  final List<TodoItemDto> _todos;
  @override
  List<TodoItemDto> get todos {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_todos);
  }

  @override
  @ServerTimestampConverter()
  final FieldValue serverTimeStamp;

  @override
  String toString() {
    return 'NoteDto(id: $id, body: $body, color: $color, todos: $todos, serverTimeStamp: $serverTimeStamp)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NoteDto &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.body, body) &&
            const DeepCollectionEquality().equals(other.color, color) &&
            const DeepCollectionEquality().equals(other._todos, _todos) &&
            const DeepCollectionEquality()
                .equals(other.serverTimeStamp, serverTimeStamp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(body),
      const DeepCollectionEquality().hash(color),
      const DeepCollectionEquality().hash(_todos),
      const DeepCollectionEquality().hash(serverTimeStamp));

  @JsonKey(ignore: true)
  @override
  _$$_NoteDtoCopyWith<_$_NoteDto> get copyWith =>
      __$$_NoteDtoCopyWithImpl<_$_NoteDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_NoteDtoToJson(this);
  }
}

abstract class _NoteDto extends NoteDto {
  factory _NoteDto(
      {@JsonKey(ignore: true)
          final String? id,
      required final String body,
      required final int color,
      required final List<TodoItemDto> todos,
      @ServerTimestampConverter()
          required final FieldValue serverTimeStamp}) = _$_NoteDto;
  _NoteDto._() : super._();

  factory _NoteDto.fromJson(Map<String, dynamic> json) = _$_NoteDto.fromJson;

  @override
  @JsonKey(ignore: true)
  String? get id => throw _privateConstructorUsedError;
  @override
  String get body => throw _privateConstructorUsedError;
  @override
  int get color => throw _privateConstructorUsedError;
  @override
  List<TodoItemDto> get todos => throw _privateConstructorUsedError;
  @override
  @ServerTimestampConverter()
  FieldValue get serverTimeStamp => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_NoteDtoCopyWith<_$_NoteDto> get copyWith =>
      throw _privateConstructorUsedError;
}
