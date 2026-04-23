import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';

class SettingsMockup extends StatefulWidget {
  const SettingsMockup({super.key});

  @override
  State<SettingsMockup> createState() => _SettingsMockupState();
}

class _SettingsMockupState extends State<SettingsMockup> {
  AppThemeType _theme = AppThemeType.darkGalaxy;
  bool _notifications = true;
  final String _language = 'Türkçe';
  final String _dateFormat = 'Göreceli';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: Text(
          AppStrings.settingsTitle,
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.darkOnSurface,
          ),
        ),
        backgroundColor: AppColors.darkBackground,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkOnSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        children: [
          _SectionHeader(title: 'Görünüm'),
          _SettingsTile(
            label: AppStrings.settingsTheme,
            value: _themeName(_theme),
            icon: Icons.palette_outlined,
            onTap: () => _showThemePicker(),
          ),
          _SettingsTile(
            label: AppStrings.settingsLanguage,
            value: _language,
            icon: Icons.language_outlined,
            onTap: () {},
          ),
          _SettingsTile(
            label: AppStrings.settingsDateFormat,
            value: _dateFormat,
            icon: Icons.calendar_today_outlined,
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionHeader(title: 'Bildirimler'),
          _SettingsSwitchTile(
            label: AppStrings.settingsNotifications,
            icon: Icons.notifications_outlined,
            value: _notifications,
            onChanged: (v) => setState(() => _notifications = v),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionHeader(title: 'Hesap'),
          _SettingsTile(
            label: AppStrings.settingsAccount,
            value: 'Giriş yapılmadı',
            icon: Icons.person_outline,
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionHeader(title: 'Veri'),
          _SettingsTile(
            label: AppStrings.settingsExport,
            icon: Icons.download_outlined,
            onTap: () {},
          ),
          _SettingsTile(
            label: AppStrings.settingsDeleteAll,
            icon: Icons.delete_outline,
            isDestructive: true,
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionHeader(title: 'Diğer'),
          _SettingsTile(
            label: AppStrings.settingsAbout,
            icon: Icons.info_outline,
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.xl),
          Center(
            child: Text(
              'Mırıldan v1.0',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.darkOnSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  String _themeName(AppThemeType t) {
    switch (t) {
      case AppThemeType.darkGalaxy:
        return 'Koyu Galaxy';
      case AppThemeType.gradientNight:
        return 'Gradient Gece';
      case AppThemeType.whiteMinimal:
        return 'Beyaz Minimal';
      case AppThemeType.paper:
        return 'Kağıt';
    }
  }

  void _showThemePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.settingsTheme,
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.darkOnSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            RadioGroup<AppThemeType>(
              groupValue: _theme,
              onChanged: (v) {
                if (v != null) setState(() => _theme = v);
                Navigator.pop(context);
              },
              child: Column(
                children: AppThemeType.values
                    .map((t) => RadioListTile<AppThemeType>(
                          value: t,
                          title: Text(
                            _themeName(t),
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.darkOnSurface,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.sm,
        bottom: AppSpacing.xs,
        top: AppSpacing.xs,
      ),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.darkOnSurfaceVariant,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.label,
    required this.icon,
    required this.onTap,
    this.value,
    this.isDestructive = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final String? value;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.error : AppColors.darkOnSurface;
    return ListTile(
      leading: Icon(icon, color: color, size: 22),
      title: Text(label, style: AppTextStyles.bodyLarge.copyWith(color: color)),
      trailing: value != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.darkOnSurfaceVariant,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                const Icon(Icons.chevron_right,
                    color: AppColors.darkOnSurfaceVariant, size: 18),
              ],
            )
          : const Icon(Icons.chevron_right,
              color: AppColors.darkOnSurfaceVariant, size: 18),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  const _SettingsSwitchTile({
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Icon(icon, color: AppColors.darkOnSurface, size: 22),
      title: Text(
        label,
        style: AppTextStyles.bodyLarge.copyWith(color: AppColors.darkOnSurface),
      ),
      value: value,
      activeThumbColor: AppColors.accent,
      onChanged: onChanged,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
