import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/core/value_objects.dart';
part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({required UniqueId id}) = _User;
}

/// for build runner: flutter pub run build_runner watch --delete-conflicting-outputs