import 'package:flutter/material.dart';

import 'package:evora/theme/sketch_colors.dart';
import 'package:evora/widgets/sketch_box.dart';

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
          child: CustomPaint(painter: _GlyphPainter(s.brandStrong)),
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
  _GlyphPainter(this.accent);

  /// Used for the dashed tear line and the spark, both drawn on the white stub.
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cy = h / 2;

    // Ticket body with two semicircular perforation bites on the side edges.
    final left = w * 0.2;
    final right = w * 0.8;
    final top = h * 0.3;
    final bottom = h * 0.7;
    final notchR = h * 0.08;

    final body = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTRB(left, top, right, bottom),
        Radius.circular(w * 0.07),
      ));
    final bites = Path()
      ..addOval(Rect.fromCircle(center: Offset(left, cy), radius: notchR))
      ..addOval(Rect.fromCircle(center: Offset(right, cy), radius: notchR));
    canvas.drawPath(
      Path.combine(PathOperation.difference, body, bites),
      Paint()..color = Colors.white,
    );

    // Dashed vertical tear line splitting the stub from the main ticket.
    final tearPaint = Paint()
      ..color = accent
      ..strokeWidth = w * 0.018
      ..strokeCap = StrokeCap.round;
    final tearX = left + (right - left) * 0.34;
    const dash = 0.055, gap = 0.04;
    for (var y = top + h * 0.05; y < bottom - h * 0.02; y += h * (dash + gap)) {
      canvas.drawLine(Offset(tearX, y), Offset(tearX, y + h * dash), tearPaint);
    }

    // Four-point spark on the main panel — the "event" energy.
    canvas.drawPath(
      _spark(Offset((tearX + right) / 2, cy), w * 0.13),
      Paint()..color = accent,
    );
  }

  Path _spark(Offset c, double r) {
    final inner = r * 0.36;
    return Path()
      ..moveTo(c.dx, c.dy - r)
      ..quadraticBezierTo(c.dx + inner, c.dy - inner, c.dx + r, c.dy)
      ..quadraticBezierTo(c.dx + inner, c.dy + inner, c.dx, c.dy + r)
      ..quadraticBezierTo(c.dx - inner, c.dy + inner, c.dx - r, c.dy)
      ..quadraticBezierTo(c.dx - inner, c.dy - inner, c.dx, c.dy - r)
      ..close();
  }

  @override
  bool shouldRepaint(covariant _GlyphPainter old) => old.accent != accent;
}
