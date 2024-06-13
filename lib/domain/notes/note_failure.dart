import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_failure.freezed.dart';

@freezed
abstract class NoteFailure with _$NoteFailure {
  const factory NoteFailure.unexpected() = Unexpected;
  const factory NoteFailure.insufficientPermissions() = InsufficientPermissions;
  const factory NoteFailure.unableToUpdate() = UnableToUpdate;
}
