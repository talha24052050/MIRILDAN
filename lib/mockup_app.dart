import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/presentation/mockups/onboarding_mockup.dart';
import 'features/galaxy/presentation/mockups/galaxy_mockup.dart';
import 'features/recording/presentation/mockups/recording_mockup.dart';
import 'features/settings/presentation/mockups/settings_mockup.dart';

// Aşama 2 mockup navigator'ı — gerçek uygulama değil, tasarım önizlemesi
class MockupApp extends StatelessWidget {
  const MockupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mırıldan — Mockup',
      theme: AppTheme.darkGalaxy(),
      debugShowCheckedModeBanner: false,
      home: const MockupMenu(),
    );
  }
}

class MockupMenu extends StatelessWidget {
  const MockupMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mırıldan Mockuplar')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _MockupTile(
            title: 'Onboarding (3 ekran)',
            subtitle: 'İlk açılış akışı',
            color: AppColors.emotionPurple,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OnboardingMockup()),
            ),
          ),
          _MockupTile(
            title: 'Galaxy — Dolu',
            subtitle: 'Kayıtlar olan ana ekran',
            color: AppColors.emotionBlue,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GalaxyMockup()),
            ),
          ),
          _MockupTile(
            title: 'Galaxy — Boş',
            subtitle: 'Henüz kayıt yok hali',
            color: AppColors.accent,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const GalaxyMockup(isEmpty: true),
              ),
            ),
          ),
          _MockupTile(
            title: 'Ses Kaydı + Renk Seçimi',
            subtitle: 'Kayıt oluşturma akışı',
            color: AppColors.emotionRed,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RecordingMockup()),
            ),
          ),
          _MockupTile(
            title: 'Ayarlar',
            subtitle: 'Tema, dil, bildirim ayarları',
            color: AppColors.emotionGreen,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsMockup()),
            ),
          ),
        ],
      ),
    );
  }
}

class _MockupTile extends StatelessWidget {
  const _MockupTile({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.2),
          ),
          child: Icon(Icons.arrow_forward_ios_rounded, color: color, size: 16),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
