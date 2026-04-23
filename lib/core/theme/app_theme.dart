import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_spacing.dart';

enum AppThemeType { darkGalaxy, gradientNight, whiteMinimal, paper }

class AppTheme {
  AppTheme._();

  static ThemeData darkGalaxy() => _build(
        brightness: Brightness.dark,
        background: AppColors.darkBackground,
        surface: AppColors.darkSurface,
        surfaceVariant: AppColors.darkSurfaceVariant,
        onSurface: AppColors.darkOnSurface,
        onSurfaceVariant: AppColors.darkOnSurfaceVariant,
        divider: AppColors.darkDivider,
        systemUiOverlay: SystemUiOverlayStyle.light,
      );

  static ThemeData gradientNight() => _build(
        brightness: Brightness.dark,
        background: AppColors.gradientStart,
        surface: const Color(0xFF12103A),
        surfaceVariant: const Color(0xFF1E1B4B),
        onSurface: AppColors.darkOnSurface,
        onSurfaceVariant: AppColors.darkOnSurfaceVariant,
        divider: const Color(0xFF1E1B4B),
        systemUiOverlay: SystemUiOverlayStyle.light,
      );

  static ThemeData whiteMinimal() => _build(
        brightness: Brightness.light,
        background: AppColors.lightBackground,
        surface: AppColors.lightSurface,
        surfaceVariant: AppColors.lightSurfaceVariant,
        onSurface: AppColors.lightOnSurface,
        onSurfaceVariant: AppColors.lightOnSurfaceVariant,
        divider: AppColors.lightDivider,
        systemUiOverlay: SystemUiOverlayStyle.dark,
      );

  static ThemeData paper() => _build(
        brightness: Brightness.light,
        background: AppColors.paperBackground,
        surface: AppColors.paperSurface,
        surfaceVariant: AppColors.paperSurfaceVariant,
        onSurface: AppColors.paperOnSurface,
        onSurfaceVariant: AppColors.paperOnSurfaceVariant,
        divider: AppColors.paperSurfaceVariant,
        systemUiOverlay: SystemUiOverlayStyle.dark,
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color surfaceVariant,
    required Color onSurface,
    required Color onSurfaceVariant,
    required Color divider,
    required SystemUiOverlayStyle systemUiOverlay,
  }) {
    final textTheme = TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(color: onSurface),
      displayMedium: AppTextStyles.displayMedium.copyWith(color: onSurface),
      headlineLarge: AppTextStyles.headlineLarge.copyWith(color: onSurface),
      headlineMedium: AppTextStyles.headlineMedium.copyWith(color: onSurface),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: onSurface),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: onSurfaceVariant),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: onSurfaceVariant),
      labelLarge: AppTextStyles.labelLarge.copyWith(color: onSurface),
      labelSmall: AppTextStyles.labelSmall.copyWith(color: onSurfaceVariant),
    );

    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: AppColors.accent,
        onPrimary: Colors.white,
        secondary: AppColors.accentMuted,
        onSecondary: AppColors.accent,
        error: AppColors.error,
        onError: Colors.white,
        surface: surface,
        onSurface: onSurface,
        surfaceContainerHighest: surfaceVariant,
        onSurfaceVariant: onSurfaceVariant,
        outline: divider,
        outlineVariant: divider,
      ),
      textTheme: textTheme,
      dividerColor: divider,
      dividerTheme: DividerThemeData(color: divider, thickness: 1),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: systemUiOverlay,
        titleTextStyle: AppTextStyles.headlineMedium.copyWith(color: onSurface),
        iconTheme: IconThemeData(color: onSurface),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: onSurfaceVariant,
          textStyle: AppTextStyles.bodyMedium,
        ),
      ),
      useMaterial3: true,
    );
  }
}
