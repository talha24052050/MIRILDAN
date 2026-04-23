import 'package:flutter/material.dart';

// Duygu renk paleti — 8 renk
class AppColors {
  AppColors._();

  static const Color emotionYellow = Color(0xFFFFD166);
  static const Color emotionBlue = Color(0xFF4A90D9);
  static const Color emotionRed = Color(0xFFE05C5C);
  static const Color emotionGreen = Color(0xFF6BCB77);
  static const Color emotionPurple = Color(0xFF9B72CF);
  static const Color emotionGray = Color(0xFF9E9E9E);
  static const Color emotionPink = Color(0xFFFF8FAB);
  static const Color emotionOrange = Color(0xFFFF9A3C);

  static const List<Color> emotionColors = [
    emotionYellow,
    emotionBlue,
    emotionRed,
    emotionGreen,
    emotionPurple,
    emotionGray,
    emotionPink,
    emotionOrange,
  ];

  // Koyu Galaxy teması
  static const Color darkBackground = Color(0xFF080B14);
  static const Color darkSurface = Color(0xFF111827);
  static const Color darkSurfaceVariant = Color(0xFF1E2A3A);
  static const Color darkOnSurface = Color(0xFFE8EAF0);
  static const Color darkOnSurfaceVariant = Color(0xFF8A93A8);
  static const Color darkDivider = Color(0xFF1E2A3A);

  // Gradient Gece teması
  static const Color gradientStart = Color(0xFF0D0D2B);
  static const Color gradientEnd = Color(0xFF1A0533);

  // Beyaz Minimal teması
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF0F2F5);
  static const Color lightOnSurface = Color(0xFF1A1A2E);
  static const Color lightOnSurfaceVariant = Color(0xFF6B7280);
  static const Color lightDivider = Color(0xFFE5E7EB);

  // Kağıt teması
  static const Color paperBackground = Color(0xFFF5F0E8);
  static const Color paperSurface = Color(0xFFFAF7F2);
  static const Color paperSurfaceVariant = Color(0xFFEDE8DF);
  static const Color paperOnSurface = Color(0xFF2C2416);
  static const Color paperOnSurfaceVariant = Color(0xFF7A6E5F);

  // Ortak
  static const Color accent = Color(0xFF7C6AF7);
  static const Color accentMuted = Color(0x337C6AF7);
  static const Color error = Color(0xFFE05C5C);
  static const Color success = Color(0xFF6BCB77);
  static const Color transparent = Colors.transparent;
}
