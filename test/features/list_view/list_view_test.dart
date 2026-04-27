import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mirildan/core/constants/app_strings.dart';
import 'package:mirildan/data/models/entry.dart';
import 'package:mirildan/features/list_view/data/audio_player_service.dart';
import 'package:mirildan/features/list_view/presentation/list_view_screen.dart';
import 'package:mirildan/features/list_view/presentation/widgets/entry_list_tile.dart';
import 'package:mirildan/features/list_view/presentation/widgets/filter_bar.dart';
import 'package:mirildan/features/list_view/providers/list_view_providers.dart';

// ── Fake AudioPlayerService ──────────────────────────────────────────────────

class _FakeAudioPlayerService implements AudioPlayerService {
  @override
  bool get isPlaying => false;
  @override
  Duration? get duration => const Duration(seconds: 10);
  @override
  Stream<Duration> get positionStream => const Stream.empty();
  @override
  Stream<bool> get playingStream => const Stream.empty();
  @override
  Stream<ProcessingState> get processingStateStream => const Stream.empty();
  @override
  Future<void> load(String path) async {}
  @override
  Future<void> play() async {}
  @override
  Future<void> pause() async {}
  @override
  Future<void> seek(Duration pos) async {}
  @override
  Future<void> seekToStart() async {}
  @override
  Future<void> stop() async {}
  @override
  void dispose() {}
}

class _FakePlayerNotifier extends PlayerNotifier {
  @override
  int? build() => null;
  @override
  Future<void> toggle(Entry entry) async {}
  @override
  Future<void> stop() async {}
}

// ── Test verisi ───────────────────────────────────────────────────────────────

Entry _textEntry({int id = 1}) => Entry(
  id: id,
  createdAt: DateTime(2024, 6, 1, 14, 30),
  type: EntryType.text,
  color: EntryColor.blue,
  text: 'Bugün çok mutluydum',
);

Entry _audioEntry({int id = 2}) => Entry(
  id: id,
  createdAt: DateTime(2024, 6, 1, 9, 0),
  type: EntryType.audio,
  color: EntryColor.red,
  audioPath: '/fake/audio.m4a',
  audioDurationMs: 5000,
);

// ── Testler ───────────────────────────────────────────────────────────────────

void main() {
  setUpAll(() => initializeDateFormatting('tr_TR'));

  group('ListViewScreen', () {
    testWidgets('boş liste — empty state gösterir', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            filteredEntriesProvider.overrideWith((_) async => <Entry>[]),
            audioPlayerServiceProvider.overrideWithValue(
              _FakeAudioPlayerService(),
            ),
            playerProvider.overrideWith(() => _FakePlayerNotifier()),
          ],
          child: const MaterialApp(home: ListViewScreen()),
        ),
      );
      await tester.pump();

      expect(find.text(AppStrings.listViewEmpty), findsOneWidget);
      expect(find.text(AppStrings.listViewEmptySubtitle), findsOneWidget);
    });

    testWidgets('kayıt varsa içerik gösterir', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            filteredEntriesProvider.overrideWith((_) async => [_textEntry()]),
            audioPlayerServiceProvider.overrideWithValue(
              _FakeAudioPlayerService(),
            ),
            playerProvider.overrideWith(() => _FakePlayerNotifier()),
          ],
          child: const MaterialApp(home: ListViewScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Bugün çok mutluydum'), findsOneWidget);
      expect(find.text(AppStrings.listViewEmpty), findsNothing);
    });

    testWidgets('birden fazla kayıt listelenir', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            filteredEntriesProvider.overrideWith(
              (_) async => [_textEntry(id: 1), _audioEntry(id: 2)],
            ),
            audioPlayerServiceProvider.overrideWithValue(
              _FakeAudioPlayerService(),
            ),
            playerProvider.overrideWith(() => _FakePlayerNotifier()),
          ],
          child: const MaterialApp(home: ListViewScreen()),
        ),
      );
      await tester.pump();

      expect(find.byType(EntryListTile), findsNWidgets(2));
    });

    testWidgets('filtre çubuğu görünür', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            filteredEntriesProvider.overrideWith((_) async => <Entry>[]),
            audioPlayerServiceProvider.overrideWithValue(
              _FakeAudioPlayerService(),
            ),
            playerProvider.overrideWith(() => _FakePlayerNotifier()),
          ],
          child: const MaterialApp(home: ListViewScreen()),
        ),
      );
      await tester.pump();

      expect(find.byType(FilterBar), findsOneWidget);
    });
  });

  group('FilterBar', () {
    Widget wrap() => ProviderScope(
      overrides: [
        audioPlayerServiceProvider.overrideWithValue(_FakeAudioPlayerService()),
        playerProvider.overrideWith(() => _FakePlayerNotifier()),
      ],
      child: const MaterialApp(home: Scaffold(body: FilterBar())),
    );

    testWidgets('"Tümü" chip\'i görünür', (tester) async {
      await tester.pumpWidget(wrap());
      expect(find.text(AppStrings.listViewFilterAll), findsOneWidget);
    });

    testWidgets('ses ve metin filtre chip\'leri görünür', (tester) async {
      await tester.pumpWidget(wrap());
      expect(find.text(AppStrings.listViewFilterAudio), findsOneWidget);
      expect(find.text(AppStrings.listViewFilterText), findsOneWidget);
    });

    testWidgets('ses filtresine basınca filter state güncellenir', (
      tester,
    ) async {
      late WidgetRef capturedRef;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            audioPlayerServiceProvider.overrideWithValue(
              _FakeAudioPlayerService(),
            ),
            playerProvider.overrideWith(() => _FakePlayerNotifier()),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (_, ref, _) {
                  capturedRef = ref;
                  return const FilterBar();
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text(AppStrings.listViewFilterAudio));
      await tester.pump();

      expect(capturedRef.read(entryListFilterProvider).type, EntryType.audio);
    });
  });

  group('EntryListTile', () {
    Widget wrapTile(Entry entry) => ProviderScope(
      overrides: [
        audioPlayerServiceProvider.overrideWithValue(_FakeAudioPlayerService()),
        playerProvider.overrideWith(() => _FakePlayerNotifier()),
      ],
      child: MaterialApp(
        home: Scaffold(body: EntryListTile(entry: entry)),
      ),
    );

    testWidgets('metin kaydı — içeriği gösterir', (tester) async {
      await tester.pumpWidget(wrapTile(_textEntry()));
      expect(find.text('Bugün çok mutluydum'), findsOneWidget);
    });

    testWidgets('ses kaydı — süreyi gösterir', (tester) async {
      await tester.pumpWidget(wrapTile(_audioEntry()));
      // 5000 ms → "0:05"
      expect(find.text('0:05'), findsOneWidget);
    });

    testWidgets('saat etiketi gösterir', (tester) async {
      await tester.pumpWidget(wrapTile(_textEntry()));
      // createdAt = 14:30
      expect(find.text('14:30'), findsOneWidget);
    });

    testWidgets('sola kaydırınca silme diyalogu açılır', (tester) async {
      await tester.pumpWidget(wrapTile(_textEntry()));
      await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.listViewDeleteTitle), findsOneWidget);
      expect(find.text(AppStrings.listViewDeleteBody), findsOneWidget);
    });

    testWidgets('silme diyalogu — "Vazgeç" seçince tile kalır', (tester) async {
      await tester.pumpWidget(wrapTile(_textEntry()));
      await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.listViewDeleteCancel));
      await tester.pumpAndSettle();

      expect(find.text('Bugün çok mutluydum'), findsOneWidget);
    });
  });
}
