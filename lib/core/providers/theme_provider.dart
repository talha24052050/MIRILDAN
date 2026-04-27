import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

const _themeKey = 'selected_theme';

class ThemeNotifier extends Notifier<AppThemeType> {
  @override
  AppThemeType build() {
    _loadSaved();
    return AppThemeType.darkGalaxy;
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_themeKey);
    if (saved != null) {
      final type = AppThemeType.values
          .where((t) => t.name == saved)
          .firstOrNull;
      if (type != null && type != state) state = type;
    }
  }

  Future<void> setTheme(AppThemeType type) async {
    state = type;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, type.name);
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, AppThemeType>(
  ThemeNotifier.new,
);
