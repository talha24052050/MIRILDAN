import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mirildan/core/constants/app_strings.dart';
import 'package:mirildan/features/recording/domain/recording_state.dart';
import 'package:mirildan/features/recording/presentation/recording_screen.dart';
import 'package:mirildan/features/recording/providers/recording_providers.dart';

class _FakeRecordingController extends RecordingController {
  @override
  RecordingState build() => const RecordingState.idle();

  @override
  Future<void> startRecording() async {
    state = RecordingState.recording(elapsed: Duration.zero, amplitude: 0.5);
  }

  @override
  Future<String?> stopRecording() async {
    state = const RecordingState.done(
      audioPath: '/fake/audio.m4a',
      duration: Duration(seconds: 5),
    );
    return '/fake/audio.m4a';
  }

  @override
  Future<void> cancelRecording() async {
    state = const RecordingState.idle();
  }
}

// GoRouter ile sarılmış wrapper — GoRouter.of(context) çağrılarının çalışması için gerekli
Widget _wrapWithProviders(Widget child, {RecordingController? controller}) {
  return ProviderScope(
    overrides: [
      if (controller != null)
        recordingControllerProvider.overrideWith(() => controller),
    ],
    child: MaterialApp.router(
      routerConfig: GoRouter(
        initialLocation: '/recording',
        routes: [
          GoRoute(path: '/', builder: (_, _) => const SizedBox()),
          GoRoute(path: '/recording', builder: (_, _) => child),
          GoRoute(
            path: '/recording/color-picker',
            builder: (_, _) => const SizedBox(),
          ),
        ],
      ),
    ),
  );
}

void main() {
  group('RecordingScreen', () {
    testWidgets('kayıt butonu idle modda görünür', (tester) async {
      await tester.pumpWidget(
        _wrapWithProviders(
          const RecordingScreen(),
          controller: _FakeRecordingController(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.mic_rounded), findsOneWidget);
      expect(find.text(AppStrings.recordHold), findsOneWidget);
    });

    testWidgets('Yaz butonu metin moduna geçer', (tester) async {
      await tester.pumpWidget(
        _wrapWithProviders(
          const RecordingScreen(),
          controller: _FakeRecordingController(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.recordWrite));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.recordTextHint), findsOneWidget);
      expect(find.text(AppStrings.recordContinue), findsOneWidget);
    });

    testWidgets('Metin modu — boş metin Devam\'ı aktif etmez', (tester) async {
      await tester.pumpWidget(
        _wrapWithProviders(
          const RecordingScreen(),
          controller: _FakeRecordingController(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.recordWrite));
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.recordContinue));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.recordContinue), findsOneWidget);
    });

    testWidgets('Metin modundan ses moduna geri dönülebilir', (tester) async {
      await tester.pumpWidget(
        _wrapWithProviders(
          const RecordingScreen(),
          controller: _FakeRecordingController(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.recordWrite));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.recordSwitchToAudio), findsOneWidget);

      await tester.tap(find.text(AppStrings.recordSwitchToAudio));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.mic_rounded), findsOneWidget);
    });

    testWidgets('Metin modu — karakter sayacı görünür', (tester) async {
      await tester.pumpWidget(
        _wrapWithProviders(
          const RecordingScreen(),
          controller: _FakeRecordingController(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.recordWrite));
      await tester.pumpAndSettle();

      expect(
        find.text('0 / ${AppStrings.recordTextMaxLength}'),
        findsOneWidget,
      );
    });

    testWidgets('Metin modu — yazınca karakter sayacı güncellenir', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapWithProviders(
          const RecordingScreen(),
          controller: _FakeRecordingController(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.recordWrite));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Merhaba');
      await tester.pump();

      expect(
        find.text('7 / ${AppStrings.recordTextMaxLength}'),
        findsOneWidget,
      );
    });

    testWidgets('Boş metin modunda kapat — diyalog göstermez', (tester) async {
      await tester.pumpWidget(
        _wrapWithProviders(
          const RecordingScreen(),
          controller: _FakeRecordingController(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.recordWrite));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.recordCancelConfirmTitle), findsNothing);
    });

    testWidgets('Dolu metin modunda kapat — iptal diyalogu açılır', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapWithProviders(
          const RecordingScreen(),
          controller: _FakeRecordingController(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.recordWrite));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Bir şeyler yazdım');
      await tester.pump();

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.recordCancelConfirmTitle), findsOneWidget);
      expect(find.text(AppStrings.recordCancelConfirmBodyText), findsOneWidget);
    });

    testWidgets('İptal diyalogu — "Hayır" seçince ekran kapanmaz', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapWithProviders(
          const RecordingScreen(),
          controller: _FakeRecordingController(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.recordWrite));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'İptal etmeyeceğim');
      await tester.pump();

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.recordCancelConfirmNo));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.recordContinue), findsOneWidget);
    });
  });

  group('RecordButton widget', () {
    testWidgets('idle modda mic ikonu gösterir', (tester) async {
      await tester.pumpWidget(
        _wrapWithProviders(
          const RecordingScreen(),
          controller: _FakeRecordingController(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.mic_rounded), findsOneWidget);
      expect(find.byIcon(Icons.stop_rounded), findsNothing);
    });
  });
}
