import 'dart:async';
import 'package:record/record.dart';

class AudioRecorderService {
  final _recorder = AudioRecorder();

  // Amplitude 0.0 (sessiz) → 1.0 (max) aralığına normalize edilir
  Stream<double> amplitudeStream(Duration interval) => _recorder
      .onAmplitudeChanged(interval)
      .map((amp) => ((amp.current + 60.0) / 60.0).clamp(0.0, 1.0));

  Future<void> start(String path) => _recorder.start(
    const RecordConfig(encoder: AudioEncoder.aacLc, sampleRate: 44100),
    path: path,
  );

  Future<String?> stop() => _recorder.stop();

  Future<void> cancel() => _recorder.cancel();

  Future<void> dispose() => _recorder.dispose();
}
