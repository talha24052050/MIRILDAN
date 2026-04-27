import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/constants/emotion_colors.dart';
import '../../../data/models/entry.dart';

// Her nokta için hesaplanan konum + meta bilgi
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

  // 0.0–1.0 arası değer — yeni eklenen nokta animasyonu için
  final double animationValue;

  // Dışarıdan erişilebilir dot konumları (hit-test için)
  final List<GalaxyDotData> dots = [];

  static const double _baseRadius = 6.0;
  static const double _highlightRadius = 9.0;
  static const double _armSpacing = 60.0; // spiral kollar arası mesafe

  @override
  void paint(Canvas canvas, Size size) {
    dots.clear();
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

  // Fibonacci spiral algoritması — doğal dağılım sağlar
  Offset _spiralPosition(int index, int total, Offset center, Size size) {
    final goldenAngle = math.pi * (3 - math.sqrt(5)); // ~137.5°
    final angle = index * goldenAngle;

    // Merkeze yakın noktalar daha sıkışık, kenara doğru açılır
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

    if (isHighlighted) {
      // Halo efekti
      canvas.drawCircle(
        position,
        radius + 6,
        Paint()
          ..color = color.withValues(alpha: 0.25)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
    }

    // Glow katmanı
    canvas.drawCircle(
      position,
      radius + 3,
      Paint()
        ..color = color.withValues(alpha: 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
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
