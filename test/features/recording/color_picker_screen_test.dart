import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mirildan/core/constants/app_strings.dart';
import 'package:mirildan/core/constants/emotion_colors.dart';
import 'package:mirildan/features/recording/presentation/color_picker_screen.dart';

Widget _wrap(Widget child) {
  return MaterialApp(home: child);
}

void main() {
  group('ColorPickerScreen', () {
    testWidgets('başlık ve renk paleti görünür', (tester) async {
      await tester.pumpWidget(
        _wrap(const ColorPickerScreen(text: 'Test metni')),
      );

      expect(find.text(AppStrings.recordColorTitle), findsOneWidget);
      // 8 renk etiketi
      for (final color in EmotionColor.values) {
        expect(find.text(color.labelTr), findsOneWidget);
      }
    });

    testWidgets('renk seçilmeden Kaydet pasif', (tester) async {
      await tester.pumpWidget(_wrap(const ColorPickerScreen(text: 'Test')));

      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, AppStrings.recordSave),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('renk seçince Kaydet aktif olur', (tester) async {
      await tester.pumpWidget(_wrap(const ColorPickerScreen(text: 'Test')));

      await tester.tap(find.text(EmotionColor.values.first.labelTr));
      await tester.pump();

      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, AppStrings.recordSave),
      );
      expect(button.onPressed, isNotNull);
    });

    testWidgets('not alanı görünür', (tester) async {
      await tester.pumpWidget(_wrap(const ColorPickerScreen(text: 'Test')));

      expect(find.text(AppStrings.recordAddNote), findsOneWidget);
      expect(find.text(AppStrings.recordNoteHint), findsOneWidget);
    });

    testWidgets('İptal butonuna basınca onay diyalogu açılır', (tester) async {
      await tester.pumpWidget(_wrap(const ColorPickerScreen(text: 'Test')));

      // Scrollable içinde olduğundan önce görünür hale getir
      await tester.ensureVisible(find.text(AppStrings.recordCancel));
      await tester.tap(find.text(AppStrings.recordCancel));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.recordCancelConfirmTitle), findsOneWidget);
      expect(
        find.text(AppStrings.recordCancelConfirmBodyColorPicker),
        findsOneWidget,
      );
    });

    testWidgets('Onay diyalogu — "Hayır" seçince ekran kapanmaz', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const ColorPickerScreen(text: 'Test')));

      await tester.ensureVisible(find.text(AppStrings.recordCancel));
      await tester.tap(find.text(AppStrings.recordCancel));
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.recordCancelConfirmNo));
      await tester.pumpAndSettle();

      // Ekran hâlâ açık — Kaydet butonu var
      expect(find.text(AppStrings.recordSave), findsOneWidget);
    });
  });
}
