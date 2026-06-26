import 'package:flutter/material.dart';

import 'package:evora/theme/sketch_colors.dart';

class SketchBadge extends StatelessWidget {
  const SketchBadge({
    super.key,
    required this.label,
    this.icon,
    this.background,
    this.foreground,
    this.border,
  });

  final String label;
  final IconData? icon;
  final Color? background;
  final Color? foreground;
  final Color? border;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    final fg = foreground ?? s.heading;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: background ?? s.paperSoft,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border ?? s.borderDefault, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
