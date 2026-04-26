import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';

class WaveformDisplay extends StatelessWidget {
  const WaveformDisplay({
    super.key,
    required this.isRecording,
    required this.amplitude,
  });

  final bool isRecording;
  // 0.0..1.0 normalize edilmiş anlık amplitude
  final double amplitude;

  static const _barCount = 28;
  static const _baseHeights = [
    16.0,
    24.0,
    40.0,
    32.0,
    56.0,
    48.0,
    64.0,
    48.0,
    72.0,
    56.0,
    40.0,
    64.0,
    48.0,
    32.0,
    56.0,
    40.0,
    72.0,
    64.0,
    48.0,
    56.0,
    40.0,
    32.0,
    48.0,
    24.0,
    40.0,
    32.0,
    16.0,
    8.0,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(_barCount, (i) {
          final baseH = _baseHeights[i];
          final h = isRecording ? baseH * (0.4 + amplitude * 0.6) : 4.0;
          return AnimatedContainer(
            duration: Duration(milliseconds: 150 + i * 5),
            curve: Curves.easeInOut,
            width: 4,
            height: h,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: isRecording
                  ? AppColors.accent.withValues(alpha: 0.5 + (i % 3) * 0.17)
                  : AppColors.darkSurfaceVariant,
              borderRadius: BorderRadius.circular(AppRadius.sm / 2),
            ),
          );
        }),
      ),
    );
  }
}
