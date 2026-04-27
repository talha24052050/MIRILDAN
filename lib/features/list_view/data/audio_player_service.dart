import 'package:just_audio/just_audio.dart';

abstract class AudioPlayerService {
  bool get isPlaying;
  Duration? get duration;
  Stream<Duration> get positionStream;
  Stream<bool> get playingStream;
  Stream<ProcessingState> get processingStateStream;

  Future<void> load(String path);
  Future<void> play();
  Future<void> pause();
  Future<void> seek(Duration pos);
  Future<void> seekToStart();
  Future<void> stop();
  void dispose();
}

class JustAudioPlayerService implements AudioPlayerService {
  JustAudioPlayerService() : _player = AudioPlayer();
  final AudioPlayer _player;

  @override
  bool get isPlaying => _player.playing;

  @override
  Duration? get duration => _player.duration;

  @override
  Stream<Duration> get positionStream => _player.positionStream;

  @override
  Stream<bool> get playingStream => _player.playingStream;

  @override
  Stream<ProcessingState> get processingStateStream =>
      _player.processingStateStream;

  @override
  Future<void> load(String path) => _player.setFilePath(path);

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration pos) => _player.seek(pos);

  @override
  Future<void> seekToStart() => _player.seek(Duration.zero);

  @override
  Future<void> stop() async {
    await _player.stop();
    await _player.seek(Duration.zero);
  }

  @override
  void dispose() => _player.dispose();
}
