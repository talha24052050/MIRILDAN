import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mirildan/core/constants/app_strings.dart';
import 'package:mirildan/core/localization/l10n/app_localizations.dart';
import 'package:mirildan/data/models/entry.dart';
import 'package:mirildan/features/galaxy/presentation/widgets/entry_detail_sheet.dart';
import 'package:mirildan/features/sharing/presentation/widgets/share_card_widget.dart';

Entry _textEntry() => Entry(
  id: 1,
  createdAt: DateTime(2024, 6, 1, 14, 30),
  type: EntryType.text,
  color: EntryColor.blue,
  text: 'Bugün huzurluydum.',
);

Entry _audioEntry() => Entry(
  id: 2,
  createdAt: DateTime(2024, 6, 2, 9, 0),
  type: EntryType.audio,
  color: EntryColor.yellow,
  audioPath: '/fake/audio.m4a',
  audioDurationMs: 5000,
);

Entry _mixedEntry() => Entry(
  id: 3,
  createdAt: DateTime(2024, 6, 3, 10, 0),
  type: EntryType.mixed,
  color: EntryColor.purple,
  text: 'İkisi birden.',
  audioPath: '/fake/mixed.m4a',
  audioDurationMs: 2000,
);

MaterialApp _l10nApp({required Widget home}) => MaterialApp(
  locale: const Locale('tr'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: home,
);

void main() {
  setUpAll(() => initializeDateFormatting('tr_TR'));

  group('ShareCardWidget', () {
    testWidgets('metin kaydı için içeriği gösterir', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ShareCardWidget(entry: _textEntry())),
        ),
      );
      await tester.pump();

      expect(find.text('Bugün huzurluydum.'), findsOneWidget);
    });

    testWidgets('ses kaydı için süreyi gösterir', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ShareCardWidget(entry: _audioEntry())),
        ),
      );
      await tester.pump();

      expect(find.text('0:05'), findsOneWidget);
    });

    testWidgets('uygulama adını gösterir', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ShareCardWidget(entry: _textEntry())),
        ),
      );
      await tester.pump();

      expect(find.text(AppStrings.appName), findsOneWidget);
    });

    testWidgets('duygu rengini gösterir', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ShareCardWidget(entry: _textEntry())),
        ),
      );
      await tester.pump();

      // blue → 'Sakin'
      expect(find.text('Sakin'), findsOneWidget);
    });

    testWidgets('mixed kayıt için hem ses hem metin gösterir', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ShareCardWidget(entry: _mixedEntry())),
        ),
      );
      await tester.pump();

      expect(find.text('İkisi birden.'), findsOneWidget);
      expect(find.byIcon(Icons.mic_rounded), findsOneWidget);
    });
  });

  group('EntryDetailSheet — paylaş butonu', () {
    testWidgets('paylaş butonu görünür', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: _l10nApp(
            home: Scaffold(body: EntryDetailSheet(entry: _textEntry())),
          ),
        ),
      );
      await tester.pump();

      expect(find.text(AppStrings.share), findsOneWidget);
    });

    testWidgets('sil butonu hâlâ görünür', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: _l10nApp(
            home: Scaffold(body: EntryDetailSheet(entry: _textEntry())),
          ),
        ),
      );
      await tester.pump();

      expect(find.text(AppStrings.listViewDeleteTitle), findsOneWidget);
    });
  });
}
