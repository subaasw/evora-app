import 'package:flutter/material.dart';

import 'package:evora/theme/pencil_shadow.dart';
import 'package:evora/theme/sketch_colors.dart';
import 'package:evora/widgets/sketch_box.dart';

/// Pill button with a dashed ink outline and the dual-layer pencil shadow.
/// Presses translate down-right and collapse the drop shadow.
class SketchButton extends StatefulWidget {
  const SketchButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.secondary = false,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool secondary;
  final bool fullWidth;

  @override
  State<SketchButton> createState() => _SketchButtonState();
}

class _SketchButtonState extends State<SketchButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    final enabled = widget.onPressed != null;
    final fill = widget.secondary ? s.paper : s.brand;
    final ring = widget.secondary ? s.brandSoft : s.brand;
    final fg = widget.secondary ? s.heading : Colors.white;

    final label = Text(
      widget.label,
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: fg, fontWeight: FontWeight.w600, fontSize: 16),
    );
    final content = Row(
      mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, size: 18, color: fg),
          const SizedBox(width: 8),
        ],
        // Flexible only inside a max-width row; a min-width row can't flex.
        widget.fullWidth ? Flexible(child: label) : label,
      ],
    );

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          transform: Matrix4.translationValues(_pressed ? 2 : 0, _pressed ? 2 : 0, 0),
          child: CustomPaint(
            foregroundPainter: DashedBorderPainter(color: s.ink, radius: 999),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              decoration: BoxDecoration(
                color: fill,
                borderRadius: BorderRadius.circular(999),
                boxShadow: enabled ? pencilShadow(ring, pressed: _pressed) : null,
              ),
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}
