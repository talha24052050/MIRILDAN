import 'package:freezed_annotation/freezed_annotation.dart';

part 'recording_state.freezed.dart';

@freezed
sealed class RecordingState with _$RecordingState {
  const factory RecordingState.idle() = RecordingIdle;
  const factory RecordingState.recording({
    required Duration elapsed,
    @Default(0.0) double amplitude,
  }) = RecordingInProgress;
  const factory RecordingState.done({
    required String audioPath,
    required Duration duration,
  }) = RecordingDone;
  const factory RecordingState.permissionDenied() = RecordingPermissionDenied;
  const factory RecordingState.error(String message) = RecordingError;
}
