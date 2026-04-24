import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';

class RecordButton extends StatelessWidget {
  const RecordButton({
    super.key,
    required this.isRecording,
    required this.onPressStart,
    required this.onPressEnd,
    this.pulseValue = 0.0,
  });

  final bool isRecording;
  final VoidCallback onPressStart;
  final VoidCallback onPressEnd;
  // 0.0..1.0 arası amplitude değeri, pulse animasyonu için
  final double pulseValue;

  @override
  Widget build(BuildContext context) {
    final scale = isRecording ? 1.0 + pulseValue * 0.12 : 1.0;
    final size = isRecording
        ? AppSize.recordButtonSizePressed
        : AppSize.recordButtonSize;
    final color = isRecording ? AppColors.error : AppColors.accent;

    return GestureDetector(
      onTapDown: (_) => onPressStart(),
      onTapUp: (_) => onPressEnd(),
      onLongPressStart: (_) => onPressStart(),
      onLongPressEnd: (_) => onPressEnd(),
      child: Transform.scale(
        scale: scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.45),
                blurRadius: 28,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Icon(
            isRecording ? Icons.stop_rounded : Icons.mic_rounded,
            color: Colors.white,
            size: AppSize.iconSizeLg,
          ),
        ),
      ),
    );
  }
}
