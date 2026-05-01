import 'dart:async';

import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/services/audio_file_service.dart';
import '../data/audio_recorder_service.dart';
import '../domain/recording_state.dart';

part 'recording_providers.g.dart';

@riverpod
class RecordingController extends _$RecordingController {
  AudioRecorderService? _service;
  Timer? _timer;
  StreamSubscription<double>? _ampSub;
  Duration _elapsed = Duration.zero;
  String? _currentPath;

  @override
  RecordingState build() {
    ref.onDispose(_cleanup);
    return const RecordingState.idle();
  }

  Future<void> startRecording() async {
    if (state is RecordingInProgress) return;

    final permission = await Permission.microphone.request();
    if (!permission.isGranted) {
      state = const RecordingState.permissionDenied();
      return;
    }

    try {
      _service ??= AudioRecorderService();
      _currentPath = await AudioFileService.generatePath();
      await _service!.start(_currentPath!);

      _elapsed = Duration.zero;
      state = RecordingState.recording(elapsed: _elapsed);

      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _elapsed += const Duration(seconds: 1);
        final current = state;
        if (current is RecordingInProgress) {
          state = current.copyWith(elapsed: _elapsed);
        }
      });

      _ampSub = _service!
          .amplitudeStream(const Duration(milliseconds: 150))
          .listen((amp) {
            final current = state;
            if (current is RecordingInProgress) {
              state = current.copyWith(amplitude: amp);
            }
          });
    } catch (e) {
      state = RecordingState.error(e.toString());
    }
  }

  Future<String?> stopRecording() async {
    _timer?.cancel();
    _timer = null;
    await _ampSub?.cancel();
    _ampSub = null;

    final path = await _service?.stop();
    if (path == null) {
      state = const RecordingState.error('Kayıt tamamlanamadı.');
      return null;
    }

    state = RecordingState.done(audioPath: path, duration: _elapsed);
    return path;
  }

  Future<void> cancelRecording() async {
    _timer?.cancel();
    _timer = null;
    await _ampSub?.cancel();
    _ampSub = null;
    await _service?.cancel();
    if (_currentPath != null) {
      await AudioFileService.delete(_currentPath!);
      _currentPath = null;
    }
    state = const RecordingState.idle();
  }

  void reset() => state = const RecordingState.idle();

  Future<void> _cleanup() async {
    _timer?.cancel();
    await _ampSub?.cancel();
    await _service?.dispose();
  }
}
