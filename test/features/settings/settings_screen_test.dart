import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mirildan/core/constants/app_strings.dart';
import 'package:mirildan/core/localization/l10n/app_localizations.dart';
import 'package:mirildan/core/providers/locale_provider.dart';
import 'package:mirildan/core/providers/theme_provider.dart';
import 'package:mirildan/core/theme/app_theme.dart';
import 'package:mirildan/features/auth/providers/auth_providers.dart';
import 'package:mirildan/features/settings/presentation/settings_screen.dart';
import 'package:mirildan/features/settings/providers/notification_provider.dart';

// Bildirim provider fake — hiçbir zaman gerçek zamanlamaya dokunmaz
class _FakeNotificationNotifier extends NotificationNotifier {
  @override
  ({bool enabled, TimeOfDay time}) build() =>
      (enabled: false, time: const TimeOfDay(hour: 20, minute: 0));
}

Widget _wrap(Widget child) => ProviderScope(
  overrides: [
    notificationProvider.overrideWith(_FakeNotificationNotifier.new),
    authStateProvider.overrideWith((ref) => Stream<User?>.value(null)),
  ],
  child: MaterialApp(
    locale: const Locale('tr'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: child,
  ),
);

void main() {
  group('SettingsScreen', () {
    testWidgets('başlık ve bölüm başlıkları görünür', (tester) async {
      await tester.pumpWidget(_wrap(const SettingsScreen()));
      await tester.pump();

      expect(find.text(AppStrings.settingsTitle), findsOneWidget);
      expect(find.text(AppStrings.settingsAppearanceSection), findsOneWidget);
      expect(
        find.text(AppStrings.settingsNotificationsSection),
        findsOneWidget,
      );
    });

    testWidgets('tema ve dil tile görünür', (tester) async {
      await tester.pumpWidget(_wrap(const SettingsScreen()));
      await tester.pump();

      expect(find.text(AppStrings.settingsTheme), findsOneWidget);
      expect(find.text(AppStrings.settingsLanguage), findsOneWidget);
    });

    testWidgets('bildirim switch kapalı başlar', (tester) async {
      await tester.pumpWidget(_wrap(const SettingsScreen()));
      await tester.pump();

      final switchFinder = find.byType(SwitchListTile);
      expect(switchFinder, findsOneWidget);
      final tile = tester.widget<SwitchListTile>(switchFinder);
      expect(tile.value, false);
    });

    testWidgets('misafir kullanıcı Auth butonu gösterir', (tester) async {
      await tester.pumpWidget(_wrap(const SettingsScreen()));
      await tester.pump();

      expect(find.text(AppStrings.settingsGuest), findsOneWidget);
    });

    testWidgets('tema seçici bottom sheet açılır', (tester) async {
      await tester.pumpWidget(_wrap(const SettingsScreen()));
      await tester.pump();

      await tester.tap(find.text(AppStrings.settingsTheme));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.settingsThemeDarkGalaxy), findsWidgets);
      expect(find.text(AppStrings.settingsThemeWhiteMinimal), findsWidgets);
    });
  });

  group('ThemeNotifier', () {
    test('varsayılan tema darkGalaxy', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(container.read(themeProvider), AppThemeType.darkGalaxy);
    });
  });

  group('LocaleNotifier', () {
    test('varsayılan dil Türkçe', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(container.read(localeProvider).languageCode, 'tr');
    });

    test('dil değiştirme çalışır', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(localeProvider.notifier).setLanguageCode('en');
      expect(container.read(localeProvider).languageCode, 'en');
    });
  });
}
