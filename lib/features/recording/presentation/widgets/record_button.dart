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

    // Basılı tut → kayıt başlar, bırak → kayıt biter.
    // onLongPressStart + onLongPressEnd kullanılır; onTap kullanılmaz.
    // Kısa dokunuşta (longPress threshold'u dolmadan bırakma) onLongPressCancel
    // tetiklenir — o durumda da kaydı temizlemek için onPressEnd çağrılır.
    return GestureDetector(
      onLongPressStart: (_) => onPressStart(),
      onLongPressEnd: (_) => onPressEnd(),
      onLongPressCancel: () => onPressEnd(),
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
