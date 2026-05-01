import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/repositories/preferences_repository.dart';
import '../../features/auth/presentation/auth_screen.dart';
import '../../features/galaxy/presentation/galaxy_screen.dart';
import '../../features/list_view/presentation/list_view_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/recording/presentation/color_picker_screen.dart';
import '../../features/recording/presentation/recording_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';

part 'routes.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.galaxy,
  debugLogDiagnostics: false,
  redirect: (context, state) async {
    final to = state.uri.path;
    if (to == AppRoutes.onboarding || to == AppRoutes.auth) return null;

    try {
      final prefs = await PreferencesRepository().get();
      if (!prefs.onboardingCompleted) return AppRoutes.onboarding;
    } catch (_) {}
    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const OnboardingScreen(),
        transitionsBuilder: (context, animation, _, child) => FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.auth,
      name: 'auth',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const AuthScreen(),
        transitionsBuilder: (context, animation, _, child) => FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.galaxy,
      name: 'galaxy',
      // Uzayda belirme hissi: hafif zoom-in + fade
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const GalaxyScreen(),
        transitionsBuilder: (context, animation, _, child) {
          final fade = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          );
          final scale = Tween<double>(begin: 0.94, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          );
          return FadeTransition(
            opacity: fade,
            child: ScaleTransition(scale: scale, child: child),
          );
        },
      ),
    ),
    GoRoute(
      path: AppRoutes.record,
      name: 'record',
      // Kayıt ekranı aşağıdan yükselir
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const RecordingScreen(),
        transitionsBuilder: (context, animation, _, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
          child: child,
        ),
      ),
      routes: [
        GoRoute(
          path: AppRoutes.colorPickerRelative,
          name: 'colorPicker',
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            return CustomTransitionPage(
              key: state.pageKey,
              child: ColorPickerScreen(
                audioPath: extra['audioPath'] as String?,
                audioDurationMs: extra['durationMs'] as int?,
                text: extra['text'] as String?,
              ),
              transitionsBuilder: (context, animation, _, child) =>
                  SlideTransition(
                    position: animation.drive(
                      Tween(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).chain(CurveTween(curve: Curves.easeOutCubic)),
                    ),
                    child: child,
                  ),
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.entryDetail,
      name: 'entryDetail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return _PlaceholderScreen(title: 'Kayıt Detay: $id');
      },
    ),
    GoRoute(
      path: AppRoutes.listView,
      name: 'listView',
      // Liste sağdan kayarak gelir
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ListViewScreen(),
        transitionsBuilder: (context, animation, _, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
          child: FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: child,
          ),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.settings,
      name: 'settings',
      // Ayarlar aşağıdan yükselir
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SettingsScreen(),
        transitionsBuilder: (context, animation, _, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
          child: FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: child,
          ),
        ),
      ),
    ),
  ],
  errorBuilder: (context, state) =>
      Scaffold(body: Center(child: Text('Sayfa bulunamadı: ${state.uri}'))),
);

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text('$title ekranı — Aşama ${_phaseFor(title)}\'de gelecek'),
      ),
    );
  }

  String _phaseFor(String title) {
    if (title.contains('Onboarding')) return '9';
    if (title.contains('Galaxy')) return '8';
    if (title.contains('Kayıt')) return '5-6';
    if (title.contains('Liste')) return '7';
    if (title.contains('Ayarlar')) return '10';
    return '?';
  }
}
