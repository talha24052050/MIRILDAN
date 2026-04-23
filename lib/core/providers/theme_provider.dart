import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';

class ThemeNotifier extends Notifier<AppThemeType> {
  @override
  AppThemeType build() => AppThemeType.darkGalaxy;

  void setTheme(AppThemeType type) => state = type;
}

final themeProvider = NotifierProvider<ThemeNotifier, AppThemeType>(
  ThemeNotifier.new,
);
