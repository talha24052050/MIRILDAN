import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/l10n_extensions.dart';

class DateGroupHeader extends StatelessWidget {
  const DateGroupHeader({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.xs,
      ),
      child: Text(
        _label(context, date),
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.darkOnSurfaceVariant,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  String _label(BuildContext context, DateTime date) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final d = DateTime(date.year, date.month, date.day);

    if (d == today) return l10n.listViewToday.toUpperCase();
    if (d == yesterday) return l10n.listViewYesterday.toUpperCase();
    return DateFormat('d MMMM yyyy', 'tr_TR').format(date).toUpperCase();
  }
}
