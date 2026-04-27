import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/emotion_colors.dart';
import '../../../../core/utils/duration_formatter.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../data/models/entry.dart';
import '../../../../data/repositories/entry_repository.dart';
import '../../../../data/services/audio_file_service.dart';
import '../../providers/list_view_providers.dart';

class EntryListTile extends ConsumerWidget {
  const EntryListTile({super.key, required this.entry});

  final Entry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentlyPlayingId = ref.watch(playerProvider);
    final isCurrentEntry = currentlyPlayingId == entry.id;
    final emotionColor = EmotionColor.values.byName(entry.color.name);

    return Dismissible(
      key: Key('entry-${entry.id}'),
      direction: DismissDirection.endToStart,
      background: _DismissBackground(),
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) async {
        if (isCurrentEntry) {
          await ref.read(playerProvider.notifier).stop();
        }
        if (entry.audioPath != null) {
          await AudioFileService.delete(entry.audioPath!);
        }
        await EntryRepository().delete(entry.id);
        ref.invalidate(filteredEntriesProvider);
      },
      child: InkWell(
        onTap: _hasAudio
            ? () => ref.read(playerProvider.notifier).toggle(entry)
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: _ColorDot(
                  color: emotionColor,
                  isPlaying: isCurrentEntry,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (_hasAudio)
                          Padding(
                            padding: const EdgeInsets.only(
                              right: AppSpacing.xs,
                            ),
                            child: Icon(
                              isCurrentEntry
                                  ? Icons.graphic_eq_rounded
                                  : Icons.mic_none_rounded,
                              size: AppSize.iconSizeSm,
                              color: isCurrentEntry
                                  ? emotionColor.color
                                  : AppColors.darkOnSurfaceVariant,
                            ),
                          ),
                        Expanded(
                          child: Text(
                            _contentPreview,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.darkOnSurface,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (entry.note != null && entry.note!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.xs),
                        child: Text(
                          entry.note!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.darkOnSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                _timeLabel(entry.createdAt),
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.darkOnSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get _hasAudio =>
      entry.type == EntryType.audio || entry.type == EntryType.mixed;

  String get _contentPreview {
    if (entry.text != null && entry.text!.isNotEmpty) return entry.text!;
    if (entry.audioDurationMs != null) {
      return DurationFormatter.format(
        Duration(milliseconds: entry.audioDurationMs!),
      );
    }
    return '—';
  }

  static String _timeLabel(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showConfirmDialog(
      context: context,
      title: AppStrings.listViewDeleteTitle,
      body: AppStrings.listViewDeleteBody,
      cancelLabel: AppStrings.listViewDeleteCancel,
      confirmLabel: AppStrings.listViewDeleteConfirm,
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({required this.color, required this.isPlaying});

  final EmotionColor color;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isPlaying ? 14 : 10,
      height: isPlaying ? 14 : 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.color,
        boxShadow: isPlaying
            ? [
                BoxShadow(
                  color: color.color.withValues(alpha: 0.5),
                  blurRadius: 8,
                ),
              ]
            : null,
      ),
    );
  }
}

class _DismissBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: AppSpacing.xl),
      color: AppColors.error.withValues(alpha: 0.15),
      child: const Icon(
        Icons.delete_outline_rounded,
        color: AppColors.error,
        size: AppSize.iconSizeMd,
      ),
    );
  }
}
