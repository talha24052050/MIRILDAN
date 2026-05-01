import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/localization/l10n_extensions.dart';
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
    final l10n = context.l10n;
    final themeType = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);
    final notif = ref.watch(notificationProvider);
    final authUser = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: [
          _SectionHeader(l10n.settingsAppearanceSection),
          _ThemeTile(current: themeType),
          _LanguageTile(current: locale.languageCode),
          _SectionHeader(l10n.settingsNotificationsSection),
          SwitchListTile(
            title: Text(l10n.settingsNotifications),
            value: notif.enabled,
            onChanged: (v) =>
                ref.read(notificationProvider.notifier).setEnabled(v),
          ),
          if (notif.enabled)
            ListTile(
              title: Text(l10n.settingsNotificationTime),
              trailing: Text(
                notif.time.format(context),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () => _pickTime(context, ref, notif.time),
            ),
          _SectionHeader(l10n.settingsAccountSection),
          authUser.when(
            data: (user) => user != null
                ? Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person_outline),
                        title: Text(
                          user.email ??
                              user.displayName ??
                              l10n.settingsAccount,
                        ),
                        subtitle: Text(user.email != null ? '' : user.uid),
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: Text(l10n.settingsSignOut),
                        onTap: () => _confirmSignOut(context, ref),
                      ),
                    ],
                  )
                : ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: Text(l10n.settingsGuest),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => context.push('/auth'),
                  ),
            loading: () => ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text(l10n.settingsGuest),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => context.push('/auth'),
            ),
            error: (_, e) => ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text(l10n.settingsGuest),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => context.push('/auth'),
            ),
          ),
          _SectionHeader(l10n.settingsDataSection),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: Text(l10n.settingsDeleteAll),
            textColor: Theme.of(context).colorScheme.error,
            iconColor: Theme.of(context).colorScheme.error,
            onTap: () => _confirmDeleteAll(context, ref),
          ),
          _SectionHeader(l10n.settingsAboutSection),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Mırıldan'),
            trailing: const Text('v1.0.0'),
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
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.settingsSignOutConfirmTitle),
        content: Text(l10n.settingsSignOutConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.settingsSignOut),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(authProvider.notifier).signOut();
    }
  }

  Future<void> _confirmDeleteAll(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.settingsDeleteAllConfirmTitle),
        content: Text(l10n.settingsDeleteAllConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.delete),
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final labels = {
      AppThemeType.darkGalaxy: l10n.settingsThemeDarkGalaxy,
      AppThemeType.gradientNight: l10n.settingsThemeGradientNight,
      AppThemeType.whiteMinimal: l10n.settingsThemeWhiteMinimal,
      AppThemeType.paper: l10n.settingsThemePaper,
    };

    return ListTile(
      leading: const Icon(Icons.palette_outlined),
      title: Text(l10n.settingsTheme),
      trailing: Text(
        labels[current] ?? current.name,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      onTap: () => _showPicker(context, ref, labels),
    );
  }

  void _showPicker(
    BuildContext context,
    WidgetRef ref,
    Map<AppThemeType, String> labels,
  ) {
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
                    title: Text(labels[t] ?? t.name),
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
    final l10n = context.l10n;
    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(l10n.settingsLanguage),
      trailing: Text(
        current == 'tr' ? l10n.settingsLanguageTr : l10n.settingsLanguageEn,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      onTap: () => _showPicker(
        context,
        ref,
        trLabel: l10n.settingsLanguageTr,
        enLabel: l10n.settingsLanguageEn,
      ),
    );
  }

  void _showPicker(
    BuildContext context,
    WidgetRef ref, {
    required String trLabel,
    required String enLabel,
  }) {
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
            children: [
              RadioListTile<String>(title: Text(trLabel), value: 'tr'),
              RadioListTile<String>(title: Text(enLabel), value: 'en'),
            ],
          ),
        ),
      ),
    );
  }
}
