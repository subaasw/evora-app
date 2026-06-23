import 'package:flutter/material.dart';

import 'package:evora/theme/sketch_colors.dart';
import 'package:evora/widgets/sketch_box.dart';

/// Evora's brand mark: a teal paper tile with a dashed ink outline holding a
/// custom glyph of three rounded bars — reads as both an "E" and stacked
/// auditorium rows.
class EvoraLogo extends StatelessWidget {
  const EvoraLogo({super.key, this.size = 72, this.withWordmark = false});

  final double size;
  final bool withWordmark;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    final tile = SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        foregroundPainter: DashedBorderPainter(color: s.ink, radius: size * 0.28),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.28),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [s.brand, s.brandStrong],
            ),
          ),
          child: CustomPaint(painter: _GlyphPainter()),
        ),
      ),
    );

    if (!withWordmark) return tile;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        tile,
        const SizedBox(height: 16),
        Text(
          'Evora',
          style: Theme.of(context)
              .textTheme
              .displaySmall
              ?.copyWith(color: s.heading),
        ),
      ],
    );
  }
}

class _GlyphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final w = size.width;
    final h = size.height;
    final barHeight = h * 0.11;
    final radius = Radius.circular(barHeight);
    final left = w * 0.28;

    const centers = [0.32, 0.5, 0.68];
    const widths = [0.46, 0.30, 0.40];

    for (var i = 0; i < centers.length; i++) {
      final top = h * centers[i] - barHeight / 2;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left, top, w * widths[i], barHeight),
          radius,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
