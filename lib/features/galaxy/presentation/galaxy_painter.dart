import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/constants/emotion_colors.dart';
import '../../../data/models/entry.dart';

class GalaxyDotData {
  const GalaxyDotData({
    required this.entry,
    required this.position,
    required this.radius,
  });

  final Entry entry;
  final Offset position;
  final double radius;
}

class GalaxyPainter extends CustomPainter {
  GalaxyPainter({
    required this.entries,
    required this.highlightedId,
    required this.animationValue,
  });

  final List<Entry> entries;
  final int? highlightedId;

  // 0.0–1.0 arası değer — pulse animasyonu için
  final double animationValue;

  final List<GalaxyDotData> dots = [];

  static const double _baseRadius = 6.0;
  static const double _highlightRadius = 9.0;
  static const double _armSpacing = 60.0;
  static const int _starCount = 140;

  @override
  void paint(Canvas canvas, Size size) {
    dots.clear();

    _drawStarField(canvas, size);

    if (entries.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final position = _spiralPosition(i, entries.length, center, size);
      final isHighlighted = entry.id == highlightedId;
      final radius = isHighlighted ? _highlightRadius : _baseRadius;

      dots.add(GalaxyDotData(entry: entry, position: position, radius: radius));
      _drawDot(canvas, entry, position, radius, isHighlighted);
    }
  }

  void _drawStarField(Canvas canvas, Size size) {
    // Sabit seed — her frame aynı yıldız konumları, animasyon yalnızca parlaklığı etkiler
    final rand = math.Random(42);

    for (int i = 0; i < _starCount; i++) {
      final x = rand.nextDouble() * size.width;
      final y = rand.nextDouble() * size.height;
      final r = rand.nextDouble() * 1.4 + 0.3;
      // Her yıldızın kendi fazı → birbirinden bağımsız titreşir
      final phase = rand.nextDouble() * math.pi * 2;
      final twinkle = 0.3 + 0.7 * ((math.sin(animationValue * math.pi * 2 + phase) + 1) / 2);
      final baseAlpha = rand.nextDouble() * 0.5 + 0.08;

      canvas.drawCircle(
        Offset(x, y),
        r,
        Paint()..color = Colors.white.withValues(alpha: baseAlpha * twinkle),
      );
    }
  }

  // Fibonacci spiral algoritması — doğal dağılım sağlar
  Offset _spiralPosition(int index, int total, Offset center, Size size) {
    final goldenAngle = math.pi * (3 - math.sqrt(5)); // ~137.5°
    final angle = index * goldenAngle;

    final maxRadius = math.min(size.width, size.height) * 0.42;
    final t = index / math.max(total - 1, 1);
    final r = math.sqrt(t) * maxRadius + _armSpacing * 0.3;

    return Offset(
      center.dx + r * math.cos(angle),
      center.dy + r * math.sin(angle),
    );
  }

  void _drawDot(
    Canvas canvas,
    Entry entry,
    Offset position,
    double radius,
    bool isHighlighted,
  ) {
    final emotionColor = EmotionColor.values.byName(entry.color.name);
    final color = emotionColor.color;

    // Glow yoğunluğu ve boyutu animasyonla nefes alır
    final breathe = 0.5 + animationValue * 0.5; // 0.5..1.0
    final glowAlpha = 0.08 + breathe * 0.14;
    final glowExtra = breathe * 2.5;

    if (isHighlighted) {
      // Halo efekti — pulse ile genişler
      canvas.drawCircle(
        position,
        radius + 8 + glowExtra,
        Paint()
          ..color = color.withValues(alpha: 0.28 * breathe)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
      );
    }

    // Glow katmanı — nefes alır
    canvas.drawCircle(
      position,
      radius + 3 + glowExtra,
      Paint()
        ..color = color.withValues(alpha: glowAlpha)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );

    // Ana nokta
    canvas.drawCircle(position, radius, Paint()..color = color);

    // Parlak merkez — beyaz ile blend
    canvas.drawCircle(
      position,
      radius * 0.35,
      Paint()
        ..color = Color.alphaBlend(
          Colors.white.withValues(alpha: 0.4),
          color.withValues(alpha: 0.8),
        ),
    );
  }

  @override
  bool shouldRepaint(GalaxyPainter old) =>
      old.entries != entries ||
      old.highlightedId != highlightedId ||
      old.animationValue != animationValue;
}
