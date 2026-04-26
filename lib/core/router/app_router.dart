import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/repositories/preferences_repository.dart';
import '../../features/auth/presentation/auth_screen.dart';
import '../../features/galaxy/presentation/galaxy_screen.dart';
import '../../features/list_view/presentation/list_view_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/recording/presentation/color_picker_screen.dart';
import '../../features/recording/presentation/recording_screen.dart';

part 'routes.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.galaxy,
  debugLogDiagnostics: false,
  redirect: (context, state) async {
    final to = state.uri.path;
    // Onboarding ve auth rotalarında döngüyü engelle
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
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.auth,
      name: 'auth',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: AppRoutes.galaxy,
      name: 'galaxy',
      builder: (context, state) => const GalaxyScreen(),
    ),
    GoRoute(
      path: AppRoutes.record,
      name: 'record',
      builder: (context, state) => const RecordingScreen(),
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
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: animation.drive(
                        Tween(
                          begin: const Offset(0, 1),
                          end: Offset.zero,
                        ).chain(CurveTween(curve: Curves.easeOutCubic)),
                      ),
                      child: child,
                    );
                  },
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
      builder: (context, state) => const ListViewScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      name: 'settings',
      builder: (context, state) => const _PlaceholderScreen(title: 'Ayarlar'),
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
