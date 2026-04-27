import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/emotion_colors.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/utils/duration_formatter.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../data/models/entry.dart';
import '../../../../data/repositories/entry_repository.dart';
import '../../../../data/services/audio_file_service.dart';
import '../../../sharing/data/sharing_service.dart';

class EntryDetailSheet extends StatefulWidget {
  const EntryDetailSheet({super.key, required this.entry, this.onDeleted});

  final Entry entry;
  final VoidCallback? onDeleted;

  static Future<void> show(
    BuildContext context,
    Entry entry, {
    VoidCallback? onDeleted,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      constraints: isTablet(context)
          ? const BoxConstraints(maxWidth: 560)
          : null,
      builder: (_) => EntryDetailSheet(entry: entry, onDeleted: onDeleted),
    );
  }

  @override
  State<EntryDetailSheet> createState() => _EntryDetailSheetState();
}

class _EntryDetailSheetState extends State<EntryDetailSheet> {
  bool _sharing = false;

  Entry get entry => widget.entry;
  VoidCallback? get onDeleted => widget.onDeleted;

  @override
  Widget build(BuildContext context) {
    final emotionColor = EmotionColor.values.byName(entry.color.name);
    final dateStr = DateFormat(
      'd MMMM yyyy, HH:mm',
      'tr_TR',
    ).format(entry.createdAt);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.md,
        AppSpacing.xl,
        AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.darkSurfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Renk + tarih
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: emotionColor.color,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                emotionColor.labelTr,
                style: AppTextStyles.labelSmall.copyWith(
                  color: emotionColor.color,
                ),
              ),
              const Spacer(),
              Text(
                dateStr,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.darkOnSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // İçerik
          if (entry.type == EntryType.audio || entry.type == EntryType.mixed)
            _AudioRow(entry: entry),

          if (entry.text != null && entry.text!.isNotEmpty) ...[
            if (entry.type == EntryType.mixed)
              const SizedBox(height: AppSpacing.md),
            Text(
              entry.text!,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.darkOnSurface,
              ),
            ),
          ],

          if (entry.note != null && entry.note!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              entry.note!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.darkOnSurfaceVariant,
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.xl),

          // Paylaş + Sil butonları
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: _sharing ? null : () => _handleShare(context),
                  icon: _sharing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.share_outlined, size: 18),
                  label: Text(context.l10n.share),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () => _handleDelete(context),
                  style: TextButton.styleFrom(foregroundColor: AppColors.error),
                  child: Text(context.l10n.listViewDeleteTitle),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _handleShare(BuildContext context) async {
    setState(() => _sharing = true);
    try {
      await SharingService.instance.shareEntry(context: context, entry: entry);
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  Future<void> _handleDelete(BuildContext context) async {
    final l10n = context.l10n;
    final confirmed = await showConfirmDialog(
      context: context,
      title: l10n.listViewDeleteTitle,
      body: l10n.listViewDeleteBody,
      cancelLabel: l10n.listViewDeleteCancel,
      confirmLabel: l10n.listViewDeleteConfirm,
    );
    if (!confirmed) return;

    if (entry.audioPath != null) {
      await AudioFileService.delete(entry.audioPath!);
    }
    await EntryRepository().delete(entry.id);

    if (context.mounted) {
      Navigator.of(context).pop();
      onDeleted?.call();
    }
  }
}

class _AudioRow extends StatelessWidget {
  const _AudioRow({required this.entry});

  final Entry entry;

  @override
  Widget build(BuildContext context) {
    final duration = entry.audioDurationMs != null
        ? DurationFormatter.format(
            Duration(milliseconds: entry.audioDurationMs!),
          )
        : '--:--';

    return Row(
      children: [
        const Icon(
          Icons.mic_rounded,
          size: 16,
          color: AppColors.darkOnSurfaceVariant,
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          duration,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.darkOnSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
