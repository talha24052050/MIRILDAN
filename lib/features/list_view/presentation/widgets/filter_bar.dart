import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/emotion_colors.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../data/models/entry.dart';
import '../../providers/list_view_providers.dart';

class FilterBar extends ConsumerWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(entryListFilterProvider);
    final notifier = ref.read(entryListFilterProvider.notifier);

    final l10n = context.l10n;
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        children: [
          _FilterChip(
            label: l10n.listViewFilterAll,
            isSelected: filter.color == null && filter.type == null,
            onTap: notifier.clear,
          ),
          const SizedBox(width: AppSpacing.sm),
          ...EmotionColor.values.map(
            (e) => Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: _ColorChip(
                emotionColor: e,
                isSelected: filter.color?.name == e.name,
                onTap: () => notifier.setColor(
                  filter.color?.name == e.name
                      ? null
                      : EntryColor.values.byName(e.name),
                ),
              ),
            ),
          ),
          _FilterChip(
            label: l10n.listViewFilterAudio,
            isSelected: filter.type == EntryType.audio,
            onTap: () => notifier.setType(
              filter.type == EntryType.audio ? null : EntryType.audio,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          _FilterChip(
            label: l10n.listViewFilterText,
            isSelected: filter.type == EntryType.text,
            onTap: () => notifier.setType(
              filter.type == EntryType.text ? null : EntryType.text,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          _FilterChip(
            label: l10n.listViewFilterMixed,
            isSelected: filter.type == EntryType.mixed,
            onTap: () => notifier.setType(
              filter.type == EntryType.mixed ? null : EntryType.mixed,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : AppColors.darkSurfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: isSelected ? Colors.white : AppColors.darkOnSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _ColorChip extends StatelessWidget {
  const _ColorChip({
    required this.emotionColor,
    required this.isSelected,
    required this.onTap,
  });

  final EmotionColor emotionColor;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: isSelected ? 32 : 24,
        height: isSelected ? 32 : 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: emotionColor.color,
          border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: emotionColor.color.withValues(alpha: 0.5),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}
