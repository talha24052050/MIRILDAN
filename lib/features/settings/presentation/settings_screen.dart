import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/repositories/preferences_repository.dart';
import '../../auth/providers/auth_providers.dart';
import '../providers/notification_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeType = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);
    final notif = ref.watch(notificationProvider);
    final authUser = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.settingsTitle)),
      body: ListView(
        children: [
          _SectionHeader(AppStrings.settingsAppearanceSection),
          _ThemeTile(current: themeType),
          _LanguageTile(current: locale.languageCode),
          _SectionHeader(AppStrings.settingsNotificationsSection),
          SwitchListTile(
            title: const Text(AppStrings.settingsNotifications),
            value: notif.enabled,
            onChanged: (v) =>
                ref.read(notificationProvider.notifier).setEnabled(v),
          ),
          if (notif.enabled)
            ListTile(
              title: const Text(AppStrings.settingsNotificationTime),
              trailing: Text(
                notif.time.format(context),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () => _pickTime(context, ref, notif.time),
            ),
          _SectionHeader(AppStrings.settingsAccountSection),
          authUser.when(
            data: (user) => user != null
                ? Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person_outline),
                        title: Text(
                          user.email ??
                              user.displayName ??
                              AppStrings.settingsAccount,
                        ),
                        subtitle: Text(user.email != null ? '' : user.uid),
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text(AppStrings.settingsSignOut),
                        onTap: () => _confirmSignOut(context, ref),
                      ),
                    ],
                  )
                : ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text(AppStrings.settingsGuest),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => context.push('/auth'),
                  ),
            loading: () => const ListTile(
              leading: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              title: Text('...'),
            ),
            error: (_, e) => const SizedBox.shrink(),
          ),
          _SectionHeader(AppStrings.settingsDataSection),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text(AppStrings.settingsDeleteAll),
            textColor: Theme.of(context).colorScheme.error,
            iconColor: Theme.of(context).colorScheme.error,
            onTap: () => _confirmDeleteAll(context, ref),
          ),
          _SectionHeader(AppStrings.settingsAboutSection),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text(AppStrings.appName),
            trailing: Text('v1.0.0'),
          ),
          SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Future<void> _pickTime(
    BuildContext context,
    WidgetRef ref,
    TimeOfDay current,
  ) async {
    final picked = await showTimePicker(context: context, initialTime: current);
    if (picked != null) {
      await ref.read(notificationProvider.notifier).setTime(picked);
    }
  }

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.settingsSignOutConfirmTitle),
        content: const Text(AppStrings.settingsSignOutConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(AppStrings.settingsSignOut),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(authProvider.notifier).signOut();
    }
  }

  Future<void> _confirmDeleteAll(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.settingsDeleteAllConfirmTitle),
        content: const Text(AppStrings.settingsDeleteAllConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await PreferencesRepository().clear();
      if (context.mounted) context.go('/onboarding');
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _ThemeTile extends ConsumerWidget {
  const _ThemeTile({required this.current});
  final AppThemeType current;

  static const _labels = {
    AppThemeType.darkGalaxy: AppStrings.settingsThemeDarkGalaxy,
    AppThemeType.gradientNight: AppStrings.settingsThemeGradientNight,
    AppThemeType.whiteMinimal: AppStrings.settingsThemeWhiteMinimal,
    AppThemeType.paper: AppStrings.settingsThemePaper,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.palette_outlined),
      title: const Text(AppStrings.settingsTheme),
      trailing: Text(
        _labels[current] ?? current.name,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      onTap: () => _showPicker(context, ref),
    );
  }

  void _showPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: RadioGroup<AppThemeType>(
          groupValue: current,
          onChanged: (v) {
            if (v != null) {
              ref.read(themeProvider.notifier).setTheme(v);
              Navigator.pop(ctx);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppThemeType.values
                .map(
                  (t) => RadioListTile<AppThemeType>(
                    title: Text(_labels[t] ?? t.name),
                    value: t,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _LanguageTile extends ConsumerWidget {
  const _LanguageTile({required this.current});
  final String current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.language),
      title: const Text(AppStrings.settingsLanguage),
      trailing: Text(
        current == 'tr'
            ? AppStrings.settingsLanguageTr
            : AppStrings.settingsLanguageEn,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      onTap: () => _showPicker(context, ref),
    );
  }

  void _showPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: RadioGroup<String>(
          groupValue: current,
          onChanged: (v) {
            if (v != null) {
              ref.read(localeProvider.notifier).setLanguageCode(v);
              Navigator.pop(ctx);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              RadioListTile<String>(
                title: Text(AppStrings.settingsLanguageTr),
                value: 'tr',
              ),
              RadioListTile<String>(
                title: Text(AppStrings.settingsLanguageEn),
                value: 'en',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
