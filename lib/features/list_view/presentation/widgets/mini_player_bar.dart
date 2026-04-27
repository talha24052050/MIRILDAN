import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/emotion_colors.dart';
import '../../../../core/utils/duration_formatter.dart';
import '../../../../data/models/entry.dart';
import '../../providers/list_view_providers.dart';

class MiniPlayerBar extends ConsumerWidget {
  const MiniPlayerBar({super.key, required this.entry});

  final Entry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(audioPlayerServiceProvider);
    final notifier = ref.read(playerProvider.notifier);
    final emotionColor = EmotionColor.values.byName(entry.color.name);

    return Container(
      color: AppColors.darkSurface,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: emotionColor.color,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  _entryPreview(entry),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.darkOnSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.close,
                  size: AppSize.iconSizeSm,
                  color: AppColors.darkOnSurfaceVariant,
                ),
                onPressed: notifier.stop,
              ),
            ],
          ),
          StreamBuilder<Duration>(
            stream: service.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              final total =
                  service.duration ??
                  Duration(milliseconds: entry.audioDurationMs ?? 0);
              final progress = total.inMilliseconds > 0
                  ? (position.inMilliseconds / total.inMilliseconds).clamp(
                      0.0,
                      1.0,
                    )
                  : 0.0;

              return Row(
                children: [
                  Text(
                    DurationFormatter.format(position),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.darkOnSurfaceVariant,
                    ),
                  ),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 2,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 6,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 12,
                        ),
                        activeTrackColor: emotionColor.color,
                        inactiveTrackColor: AppColors.darkSurfaceVariant,
                        thumbColor: emotionColor.color,
                        overlayColor: emotionColor.color.withValues(alpha: 0.2),
                      ),
                      child: Slider(
                        value: progress,
                        onChanged: (v) => service.seek(
                          Duration(
                            milliseconds: (v * total.inMilliseconds).round(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    DurationFormatter.format(total),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.darkOnSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  StreamBuilder<bool>(
                    stream: service.playingStream,
                    builder: (context, snapshot) {
                      final isPlaying = snapshot.data ?? false;
                      return GestureDetector(
                        onTap: () => notifier.toggle(entry),
                        child: Icon(
                          isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: emotionColor.color,
                          size: AppSize.iconSizeLg,
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  static String _entryPreview(Entry entry) {
    if (entry.text != null && entry.text!.isNotEmpty) return entry.text!;
    if (entry.audioDurationMs != null) {
      return '🎙 ${DurationFormatter.format(Duration(milliseconds: entry.audioDurationMs!))}';
    }
    return '—';
  }
}
