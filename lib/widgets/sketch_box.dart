import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:evora/theme/pencil_shadow.dart';
import 'package:evora/theme/sketch_colors.dart';

/// Strokes a dashed rounded-rect outline along the edge of its bounds.
class DashedBorderPainter extends CustomPainter {
  const DashedBorderPainter({
    required this.color,
    this.width = 2,
    this.radius = 24,
    this.dash = 6,
    this.gap = 4,
  });

  final Color color;
  final double width;
  final double radius;
  final double dash;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    final r = math.min(radius, size.shortestSide / 2);
    final rect = Offset.zero & size;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(rect.deflate(width / 2), Radius.circular(r)));

    for (final metric in path.computeMetrics()) {
      var dist = 0.0;
      while (dist < metric.length) {
        final len = math.min(dash, metric.length - dist);
        canvas.drawPath(metric.extractPath(dist, dist + len), paint);
        dist += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter old) =>
      old.color != color || old.radius != radius || old.width != width;
}

/// A "paper" surface: fill + dashed ink outline + dual-layer pencil shadow.
class SketchBox extends StatelessWidget {
  const SketchBox({
    super.key,
    required this.child,
    required this.fill,
    this.radius = 24,
    this.padding = const EdgeInsets.all(24),
    this.shadow,
  });

  final Widget child;
  final Color fill;
  final double radius;
  final EdgeInsetsGeometry padding;

  /// Defaults to a pencil shadow whose ring matches [fill].
  final List<BoxShadow>? shadow;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter:
          DashedBorderPainter(color: context.sketch.ink, radius: radius),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: shadow ?? pencilShadow(fill),
        ),
        child: child,
      ),
    );
  }
}

/// Default cream card per the design system.
class SketchCard extends StatelessWidget {
  const SketchCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SketchBox(fill: context.sketch.paper, padding: padding, child: child);
  }
}
