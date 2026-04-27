import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/entry.dart';
import '../../../data/repositories/entry_repository.dart';
import '../data/audio_player_service.dart';

part 'list_view_providers.g.dart';

// Filtre durumu — renk ve tip seçimi
@riverpod
class EntryListFilter extends _$EntryListFilter {
  @override
  ({EntryColor? color, EntryType? type}) build() => (color: null, type: null);

  void setColor(EntryColor? color) => state = (color: color, type: state.type);

  void setType(EntryType? type) => state = (color: state.color, type: type);

  void clear() => state = (color: null, type: null);
}

// Filtreli kayıt listesi
@riverpod
Future<List<Entry>> filteredEntries(Ref ref) {
  final filter = ref.watch(entryListFilterProvider);
  return EntryRepository().getAll(color: filter.color, type: filter.type);
}

// Ses oynatıcı servisi — uygulama boyunca tekil
@Riverpod(keepAlive: true)
AudioPlayerService audioPlayerService(Ref ref) {
  final service = JustAudioPlayerService();
  ref.onDispose(service.dispose);
  return service;
}

// Oynatıcı kontrolcüsü — hangi kaydın çaldığını ve durumu yönetir
// Durum: çalan kaydın id'si (null = hiçbir şey çalmıyor)
@Riverpod(keepAlive: true)
class PlayerNotifier extends _$PlayerNotifier {
  StreamSubscription<ProcessingState>? _completionSub;

  @override
  int? build() {
    ref.onDispose(() => _completionSub?.cancel());
    return null;
  }

  Future<void> toggle(Entry entry) async {
    if (entry.audioPath == null) return;
    final service = ref.read(audioPlayerServiceProvider);

    if (state == entry.id) {
      // Aynı kayıt — duraklat/devam et
      if (service.isPlaying) {
        await service.pause();
      } else {
        await service.play();
      }
      return;
    }

    // Farklı kayıt — mevcut kaydı durdur, yenisini başlat
    _completionSub?.cancel();
    await service.stop();
    state = entry.id;
    await service.load(entry.audioPath!);
    await service.play();

    // Kayıt bitince otomatik sıfırla
    _completionSub = service.processingStateStream.listen((ps) {
      if (ps == ProcessingState.completed && state == entry.id) {
        service.seekToStart();
        state = null;
      }
    });
  }

  Future<void> stop() async {
    _completionSub?.cancel();
    _completionSub = null;
    await ref.read(audioPlayerServiceProvider).stop();
    state = null;
  }
}
