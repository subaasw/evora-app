import 'package:flutter/material.dart';

/// Dual-layer hand-drawn shadow: a 4px solid ring (matches the surface, or the
/// brand for buttons) plus a graphite offset drop. Collapses to the ring when
/// pressed so the surface "meets" its own shadow.
List<BoxShadow> pencilShadow(Color ring, {bool pressed = false, bool hover = false}) {
  final offset = pressed ? 0.0 : (hover ? 1.0 : 2.0);
  return [
    BoxShadow(color: ring, spreadRadius: 4),
    if (!pressed)
      BoxShadow(
        color: const Color(0x80000000),
        offset: Offset(offset, offset),
        blurRadius: 4,
        spreadRadius: 2,
      ),
  ];
}
