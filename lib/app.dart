import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/localization/l10n/app_localizations.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class MiriildanApp extends ConsumerWidget {
  const MiriildanApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeType = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Mırıldan',
      debugShowCheckedModeBanner: false,
      theme: _themeData(themeType),
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: appRouter,
    );
  }

  ThemeData _themeData(AppThemeType type) {
    switch (type) {
      case AppThemeType.darkGalaxy:
        return AppTheme.darkGalaxy();
      case AppThemeType.gradientNight:
        return AppTheme.gradientNight();
      case AppThemeType.whiteMinimal:
        return AppTheme.whiteMinimal();
      case AppThemeType.paper:
        return AppTheme.paper();
    }
  }
}
