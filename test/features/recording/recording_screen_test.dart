import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mirildan/features/recording/domain/recording_state.dart';
import 'package:mirildan/features/recording/presentation/recording_screen.dart';
import 'package:mirildan/features/recording/providers/recording_providers.dart';

// Test için sahte controller — gerçek mikrofon/dosya sistemi kullanmaz
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

Widget _wrapWithProviders(Widget child, {RecordingController? controller}) {
  return ProviderScope(
    overrides: [
      if (controller != null)
        recordingControllerProvider.overrideWith(() => controller),
    ],
    child: MaterialApp(home: child),
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

      expect(find.byIcon(Icons.mic_rounded), findsOneWidget);
      expect(find.text('Konuşmak için basılı tut'), findsOneWidget);
    });

    testWidgets('Yaz butonu metin moduna geçer', (tester) async {
      await tester.pumpWidget(
        _wrapWithProviders(
          const RecordingScreen(),
          controller: _FakeRecordingController(),
        ),
      );

      await tester.tap(find.text('Yaz'));
      await tester.pumpAndSettle();

      expect(find.text('Ne hissediyorsun?'), findsOneWidget);
      expect(find.text('Devam'), findsOneWidget);
    });

    testWidgets('Metin modu — boş metin Devam\'ı aktif etmez', (tester) async {
      await tester.pumpWidget(
        _wrapWithProviders(
          const RecordingScreen(),
          controller: _FakeRecordingController(),
        ),
      );

      await tester.tap(find.text('Yaz'));
      await tester.pumpAndSettle();

      // TextField boşken Devam butonuna bas — navigate etmemeli
      await tester.tap(find.text('Devam'));
      await tester.pumpAndSettle();

      // Hâlâ aynı ekranda
      expect(find.text('Devam'), findsOneWidget);
    });

    testWidgets('Metin modundan ses moduna geri dönülebilir', (tester) async {
      await tester.pumpWidget(
        _wrapWithProviders(
          const RecordingScreen(),
          controller: _FakeRecordingController(),
        ),
      );

      await tester.tap(find.text('Yaz'));
      await tester.pumpAndSettle();
      expect(find.text('Ses'), findsOneWidget);

      await tester.tap(find.text('Ses'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.mic_rounded), findsOneWidget);
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
      expect(find.byIcon(Icons.mic_rounded), findsOneWidget);
      expect(find.byIcon(Icons.stop_rounded), findsNothing);
    });
  });
}
