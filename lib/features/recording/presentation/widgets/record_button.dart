import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';

class RecordButton extends StatefulWidget {
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
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ringController;

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
  }

  @override
  void didUpdateWidget(RecordButton old) {
    super.didUpdateWidget(old);
    if (widget.isRecording && !old.isRecording) {
      _ringController.repeat();
    } else if (!widget.isRecording && old.isRecording) {
      _ringController.stop();
      _ringController.reset();
    }
  }

  @override
  void dispose() {
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.isRecording ? 1.0 + widget.pulseValue * 0.10 : 1.0;
    final size = widget.isRecording
        ? AppSize.recordButtonSizePressed
        : AppSize.recordButtonSize;
    final color = widget.isRecording ? AppColors.error : AppColors.accent;

    // Basılı tut → kayıt başlar, bırak → kayıt biter.
    // onLongPressStart + onLongPressEnd kullanılır; onTap kullanılmaz.
    // Kısa dokunuşta (longPress threshold'u dolmadan bırakma) onLongPressCancel
    // tetiklenir — o durumda da kaydı temizlemek için onPressEnd çağrılır.
    return GestureDetector(
      onLongPressStart: (_) => widget.onPressStart(),
      onLongPressEnd: (_) => widget.onPressEnd(),
      onLongPressCancel: () => widget.onPressEnd(),
      child: SizedBox(
        width: size + 56,
        height: size + 56,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Yayılan halkalar — yalnızca kayıt sırasında
            if (widget.isRecording)
              AnimatedBuilder(
                animation: _ringController,
                builder: (_, _) => CustomPaint(
                  size: Size(size + 56, size + 56),
                  painter: _RipplePainter(
                    progress: _ringController.value,
                    color: color,
                    maxRadius: size / 2 + 28,
                  ),
                ),
              ),

            // Ana buton
            Transform.scale(
              scale: scale,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutBack,
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(
                        alpha: widget.isRecording ? 0.60 : 0.45,
                      ),
                      blurRadius: widget.isRecording ? 40 : 28,
                      spreadRadius: widget.isRecording ? 8 : 4,
                    ),
                  ],
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  transitionBuilder: (child, anim) => ScaleTransition(
                    scale: anim,
                    child: child,
                  ),
                  child: Icon(
                    widget.isRecording
                        ? Icons.stop_rounded
                        : Icons.mic_rounded,
                    key: ValueKey(widget.isRecording),
                    color: Colors.white,
                    size: AppSize.iconSizeLg,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  _RipplePainter({
    required this.progress,
    required this.color,
    required this.maxRadius,
  });

  final double progress;
  final Color color;
  final double maxRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // 2 halka birbirinden 0.5 offset ile — sürekli dışa yayılır
    for (int i = 0; i < 2; i++) {
      final p = (progress + i * 0.5) % 1.0;
      final radius = p * maxRadius;
      final alpha = (1.0 - p) * 0.45;

      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = color.withValues(alpha: alpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0,
      );
    }
  }

  @override
  bool shouldRepaint(_RipplePainter old) => old.progress != progress;
}
