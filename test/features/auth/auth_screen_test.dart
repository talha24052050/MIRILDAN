import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mirildan/core/constants/app_strings.dart';
import 'package:mirildan/features/auth/presentation/auth_screen.dart';
import 'package:mirildan/features/auth/providers/auth_providers.dart';

class _FakeAuthNotifier extends AuthNotifier {
  @override
  AuthActionState build() => AuthActionIdle();
}

Widget _wrap(Widget child) => ProviderScope(
      overrides: [
        authProvider.overrideWith(_FakeAuthNotifier.new),
      ],
      child: MaterialApp(home: child),
    );

void main() {
  group('AuthScreen', () {
    testWidgets('giriş ekranı başlığı ve alanları gösterir', (tester) async {
      await tester.pumpWidget(_wrap(const AuthScreen()));
      await tester.pump();

      expect(find.text(AppStrings.authSignInTitle), findsOneWidget);
      expect(find.text(AppStrings.authSignInWithGoogle), findsOneWidget);
      expect(find.text(AppStrings.authSignIn), findsOneWidget);
    });

    testWidgets('Google butonu görünür', (tester) async {
      await tester.pumpWidget(_wrap(const AuthScreen()));
      await tester.pump();

      expect(find.text(AppStrings.authSignInWithGoogle), findsOneWidget);
    });

    testWidgets('"Hesabın yok mu" butonuna basınca kayıt moduna geçer',
        (tester) async {
      await tester.pumpWidget(_wrap(const AuthScreen()));
      await tester.pump();

      await tester.tap(find.text(AppStrings.authNoAccount));
      await tester.pump();

      expect(find.text(AppStrings.authCreateAccountTitle), findsOneWidget);
      expect(find.text(AppStrings.authCreateAccount), findsOneWidget);
    });

    testWidgets('kayıt modundan giriş moduna geri döner', (tester) async {
      await tester.pumpWidget(_wrap(const AuthScreen()));
      await tester.pump();

      await tester.tap(find.text(AppStrings.authNoAccount));
      await tester.pump();

      await tester.tap(find.text(AppStrings.authHaveAccount));
      await tester.pump();

      expect(find.text(AppStrings.authSignInTitle), findsOneWidget);
    });

    testWidgets('hata durumu mesaj gösterir', (tester) async {
      final errorNotifier = _ErrorAuthNotifier();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authProvider.overrideWith(() => errorNotifier),
          ],
          child: const MaterialApp(home: AuthScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Bir sorun oluştu, tekrar dener misin?'), findsOneWidget);
    });
  });
}

class _ErrorAuthNotifier extends AuthNotifier {
  @override
  AuthActionState build() =>
      AuthActionError('Bir sorun oluştu, tekrar dener misin?');
}
