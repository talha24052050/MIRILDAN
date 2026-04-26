import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mirildan/core/constants/app_strings.dart';
import 'package:mirildan/data/models/entry.dart';
import 'package:mirildan/features/galaxy/presentation/galaxy_screen.dart';
import 'package:mirildan/features/galaxy/presentation/widgets/entry_detail_sheet.dart';
import 'package:mirildan/features/galaxy/providers/galaxy_providers.dart';

// ── Test verisi ────────────────────────────────────────────────────────────────

Entry _textEntry({int id = 1}) => Entry(
      id: id,
      createdAt: DateTime(2024, 6, 1, 14, 30),
      type: EntryType.text,
      color: EntryColor.blue,
      text: 'Bugün çok güzeldi',
    );

Entry _audioEntry({int id = 2}) => Entry(
      id: id,
      createdAt: DateTime(2024, 6, 2, 9, 0),
      type: EntryType.audio,
      color: EntryColor.red,
      audioPath: '/fake/audio.m4a',
      audioDurationMs: 3000,
    );

// ── Testler ────────────────────────────────────────────────────────────────────

void main() {
  setUpAll(() => initializeDateFormatting('tr_TR'));

  group('GalaxyScreen', () {
    testWidgets('boş liste — empty state gösterir', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            galaxyEntriesProvider.overrideWith((_) async => <Entry>[]),
          ],
          child: const MaterialApp(home: GalaxyScreen()),
        ),
      );
      await tester.pump();

      expect(find.text(AppStrings.galaxyEmpty), findsOneWidget);
      expect(find.text(AppStrings.galaxyEmptySubtitle), findsOneWidget);
    });

    testWidgets('boş listede kayıt butonu görünür', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            galaxyEntriesProvider.overrideWith((_) async => <Entry>[]),
          ],
          child: const MaterialApp(home: GalaxyScreen()),
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
    });

    testWidgets('kayıt varken canvas gösterir', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            galaxyEntriesProvider.overrideWith(
              (_) async => [_textEntry(), _audioEntry()],
            ),
          ],
          child: const MaterialApp(home: GalaxyScreen()),
        ),
      );
      await tester.pump();

      expect(find.byType(CustomPaint), findsWidgets);
      expect(find.text(AppStrings.galaxyEmpty), findsNothing);
    });

    testWidgets('kayıt varken sağ altta kayıt butonu var', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            galaxyEntriesProvider.overrideWith(
              (_) async => [_textEntry()],
            ),
          ],
          child: const MaterialApp(home: GalaxyScreen()),
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
    });

    testWidgets('liste ikonu AppBar\'da görünür', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            galaxyEntriesProvider.overrideWith((_) async => <Entry>[]),
          ],
          child: const MaterialApp(home: GalaxyScreen()),
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.list_rounded), findsOneWidget);
    });
  });

  group('EntryDetailSheet', () {
    testWidgets('metin kaydını gösterir', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: EntryDetailSheet(entry: _textEntry()),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Bugün çok güzeldi'), findsOneWidget);
    });

    testWidgets('ses kaydı süresini gösterir', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: EntryDetailSheet(entry: _audioEntry()),
            ),
          ),
        ),
      );
      await tester.pump();

      // 3000 ms → "0:03"
      expect(find.text('0:03'), findsOneWidget);
    });

    testWidgets('renk etiketi gösterir', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: EntryDetailSheet(entry: _textEntry()),
            ),
          ),
        ),
      );
      await tester.pump();

      // blue → 'Sakin'
      expect(find.text('Sakin'), findsOneWidget);
    });

    testWidgets('sil butonu görünür', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: EntryDetailSheet(entry: _textEntry()),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text(AppStrings.listViewDeleteTitle), findsOneWidget);
    });
  });
}
