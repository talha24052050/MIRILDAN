import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';

class GalaxyMockup extends StatelessWidget {
  const GalaxyMockup({super.key, this.isEmpty = false});
  final bool isEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          // Arka plan yıldızları
          const _StarField(),

          // Galaxy noktaları
          if (!isEmpty) const _GalaxyDots(),

          // Boş durum
          if (isEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _PulsingDot(),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    AppStrings.galaxyEmpty,
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.darkOnSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    AppStrings.galaxyEmptySubtitle,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.darkOnSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

          // Üst bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.appName,
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.darkOnSurface,
                    ),
                  ),
                  Row(
                    children: [
                      _IconButton(icon: Icons.tune_rounded, onTap: () {}),
                      const SizedBox(width: AppSpacing.sm),
                      _IconButton(icon: Icons.settings_outlined, onTap: () {}),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Alt kayıt butonları
          Positioned(bottom: 0, left: 0, right: 0, child: _BottomRecordBar()),
        ],
      ),
    );
  }
}

class _StarField extends StatelessWidget {
  const _StarField();

  static final _rng = Random(42);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: _StarPainter(_rng),
    );
  }
}

class _StarPainter extends CustomPainter {
  _StarPainter(this.rng);
  final Random rng;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.25);
    for (var i = 0; i < 80; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final r = rng.nextDouble() * 1.2 + 0.3;
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GalaxyDots extends StatelessWidget {
  const _GalaxyDots();

  static final List<_DotData> _dots = _generateDots();

  static List<_DotData> _generateDots() {
    final rng = Random(7);
    final colors = AppColors.emotionColors;
    return List.generate(32, (i) {
      final angle = i * 0.45 + rng.nextDouble() * 0.3;
      final radius = 30.0 + i * 8.0 + rng.nextDouble() * 12;
      return _DotData(
        angle: angle,
        radius: radius,
        color: colors[rng.nextInt(colors.length)],
        size: rng.nextDouble() * 6 + 5,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cx = size.width / 2;
    final cy = size.height / 2 - 40;

    return Stack(
      children: _dots.map((d) {
        final x = cx + cos(d.angle) * d.radius;
        final y = cy + sin(d.angle) * d.radius * 0.55;
        return Positioned(
          left: x - d.size / 2,
          top: y - d.size / 2,
          child: Container(
            width: d.size,
            height: d.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: d.color,
              boxShadow: [
                BoxShadow(
                  color: d.color.withValues(alpha: 0.6),
                  blurRadius: d.size * 1.5,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _DotData {
  const _DotData({
    required this.angle,
    required this.radius,
    required this.color,
    required this.size,
  });
  final double angle;
  final double radius;
  final Color color;
  final double size;
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, _) => Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.accent.withValues(alpha: _animation.value * 0.3),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: _animation.value * 0.5),
              blurRadius: 24,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accent,
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomRecordBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.lg,
        top: AppSpacing.md,
        left: AppSpacing.xl,
        right: AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.darkBackground.withValues(alpha: 0),
            AppColors.darkBackground,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Shuffle butonu
          _IconButton(icon: Icons.shuffle_rounded, onTap: () {}),

          // Kayıt butonu
          GestureDetector(
            onTap: () {},
            child: Container(
              width: AppSize.recordButtonSize,
              height: AppSize.recordButtonSize,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentMuted,
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.mic_rounded,
                color: Colors.white,
                size: AppSize.iconSizeLg,
              ),
            ),
          ),

          // Yazı ile kayıt
          _IconButton(icon: Icons.edit_outlined, onTap: () {}),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.darkSurfaceVariant,
        ),
        child: Icon(
          icon,
          color: AppColors.darkOnSurface,
          size: AppSize.iconSizeMd,
        ),
      ),
    );
  }
}
