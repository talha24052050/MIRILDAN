import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/emotion_colors.dart';
import '../../../../core/utils/duration_formatter.dart';
import '../../../../data/models/entry.dart';

class ShareCardWidget extends StatelessWidget {
  const ShareCardWidget({super.key, required this.entry});

  final Entry entry;

  static const double cardWidth = 360;
  static const double cardHeight = 360;

  @override
  Widget build(BuildContext context) {
    final emotionColor = EmotionColor.values.byName(entry.color.name);
    final base = emotionColor.color;
    final dateStr = DateFormat('d MMMM yyyy', 'tr_TR').format(entry.createdAt);

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.lerp(AppColors.darkBackground, base, 0.25)!,
              Color.lerp(AppColors.darkBackground, base, 0.08)!,
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Renk + etiket
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: base,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    emotionColor.labelTr,
                    style: AppTextStyles.labelSmall.copyWith(color: base),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // İçerik
              Expanded(
                child: _ContentSection(entry: entry, base: base),
              ),

              // Alt çizgi + uygulama adı
              const Divider(color: Color(0x22FFFFFF), height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateStr,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.darkOnSurfaceVariant,
                    ),
                  ),
                  Text(
                    'Mırıldan',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.darkOnSurfaceVariant,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContentSection extends StatelessWidget {
  const _ContentSection({required this.entry, required this.base});

  final Entry entry;
  final Color base;

  @override
  Widget build(BuildContext context) {
    final hasText = entry.text != null && entry.text!.isNotEmpty;
    final hasAudio =
        entry.type == EntryType.audio || entry.type == EntryType.mixed;

    if (hasAudio && !hasText) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.mic_rounded, size: 48, color: base.withAlpha(180)),
            const SizedBox(height: AppSpacing.sm),
            Text(
              entry.audioDurationMs != null
                  ? DurationFormatter.format(
                      Duration(milliseconds: entry.audioDurationMs!),
                    )
                  : '--:--',
              style: AppTextStyles.displayLarge.copyWith(
                color: AppColors.darkOnSurface,
                fontSize: 40,
              ),
            ),
          ],
        ),
      );
    }

    if (hasText) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (hasAudio) ...[
            Row(
              children: [
                Icon(
                  Icons.mic_rounded,
                  size: 14,
                  color: AppColors.darkOnSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  entry.audioDurationMs != null
                      ? DurationFormatter.format(
                          Duration(milliseconds: entry.audioDurationMs!),
                        )
                      : '--:--',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.darkOnSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          Text(
            entry.text!,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.darkOnSurface,
              height: 1.5,
            ),
            maxLines: 8,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
