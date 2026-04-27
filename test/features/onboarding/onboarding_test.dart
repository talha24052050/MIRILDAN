import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mirildan/core/constants/app_strings.dart';
import 'package:mirildan/features/onboarding/presentation/onboarding_screen.dart';

Widget _wrap(Widget child) => ProviderScope(child: MaterialApp(home: child));

void main() {
  group('OnboardingScreen', () {
    testWidgets('ilk sayfa başlığını gösterir', (tester) async {
      await tester.pumpWidget(_wrap(const OnboardingScreen()));
      await tester.pump();

      expect(find.text(AppStrings.onboarding1Title), findsOneWidget);
      expect(find.text(AppStrings.onboarding1Subtitle), findsOneWidget);
    });

    testWidgets('ilk sayfada Devam butonu görünür', (tester) async {
      await tester.pumpWidget(_wrap(const OnboardingScreen()));
      await tester.pump();

      expect(find.text(AppStrings.onboardingContinue), findsOneWidget);
    });

    testWidgets('Devam butonuna basınca ikinci sayfaya geçer', (tester) async {
      await tester.pumpWidget(_wrap(const OnboardingScreen()));
      await tester.pump();

      await tester.tap(find.text(AppStrings.onboardingContinue));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.onboarding2Title), findsOneWidget);
    });

    testWidgets('son sayfada Hesap Oluştur ve Şimdi değil görünür', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const OnboardingScreen()));
      await tester.pump();

      // 2. sayfaya geç
      await tester.tap(find.text(AppStrings.onboardingContinue));
      await tester.pumpAndSettle();

      // 3. sayfaya geç
      await tester.tap(find.text(AppStrings.onboardingContinue));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.onboardingCreateAccount), findsOneWidget);
      expect(find.text(AppStrings.onboardingSkip), findsOneWidget);
    });

    testWidgets('son sayfada Devam butonu gözükmez', (tester) async {
      await tester.pumpWidget(_wrap(const OnboardingScreen()));
      await tester.pump();

      await tester.tap(find.text(AppStrings.onboardingContinue));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.onboardingContinue));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.onboardingContinue), findsNothing);
    });
  });
}
