import 'package:flutter/material.dart';

@immutable
class SketchColors extends ThemeExtension<SketchColors> {
  const SketchColors({
    required this.canvas,
    required this.paper,
    required this.paperSoft,
    required this.ink,
    required this.brand,
    required this.brandStrong,
    required this.brandSoft,
    required this.brandSofter,
    required this.heading,
    required this.body,
    required this.bodySubtle,
    required this.borderDefault,
    required this.borderDefaultMedium,
    required this.disabled,
    required this.fgDisabled,
    required this.success,
    required this.successSoft,
    required this.danger,
    required this.dangerSoft,
    required this.warning,
    required this.warningSoft,
  });

  final Color canvas; // page background
  final Color paper; // layered surfaces (cards, modals)
  final Color paperSoft; // inputs, quiet surfaces
  final Color ink; // pinned dashed-border ink
  final Color brand;
  final Color brandStrong;
  final Color brandSoft;
  final Color brandSofter;
  final Color heading;
  final Color body;
  final Color bodySubtle;
  final Color borderDefault;
  final Color borderDefaultMedium;
  final Color disabled;
  final Color fgDisabled;
  final Color success;
  final Color successSoft;
  final Color danger;
  final Color dangerSoft;
  final Color warning;
  final Color warningSoft;

  static const Color _ink = Color(0xFF2B2418);

  static const light = SketchColors(
    canvas: Color(0xFFFFFAF5),
    paper: Color(0xFFF4EDDF),
    paperSoft: Color(0xFFFFFAF5),
    ink: _ink,
    brand: Color(0xFF1DAD97),
    brandStrong: Color(0xFF168478),
    brandSoft: Color(0xFFB9EFE2),
    brandSofter: Color(0xFFE8F9F4),
    heading: Color(0xFF1F1B12),
    body: Color(0xFF4A3F2E),
    bodySubtle: Color(0xFF6F6151),
    borderDefault: Color(0xFFC9B795),
    borderDefaultMedium: Color(0xFFB0997B),
    disabled: Color(0xFFECE3D0),
    fgDisabled: Color(0xFFA89878),
    success: Color(0xFF1DAD97),
    successSoft: Color(0xFFECFDF5),
    danger: Color(0xFFC0392B),
    dangerSoft: Color(0xFFFDECEC),
    warning: Color(0xFFE69A1A),
    warningSoft: Color(0xFFFDF3E1),
  );

  static const dark = SketchColors(
    canvas: Color(0xFF14110C),
    paper: Color(0xFF221D15),
    paperSoft: Color(0xFF1A1611),
    ink: _ink,
    brand: Color(0xFF3EC3AD),
    brandStrong: Color(0xFF1DAD97),
    brandSoft: Color(0xFF168478),
    brandSofter: Color(0xFF0E574E),
    heading: Color(0xFFFFFAF5),
    body: Color(0xFFC9B795),
    bodySubtle: Color(0xFFA89878),
    borderDefault: Color(0xFF3A2F22),
    borderDefaultMedium: Color(0xFF4A3D2C),
    disabled: Color(0xFF2D261B),
    fgDisabled: Color(0xFF6F6151),
    success: Color(0xFF3EC3AD),
    successSoft: Color(0xFF002C22),
    danger: Color(0xFFE74C3C),
    dangerSoft: Color(0xFF4D1A1A),
    warning: Color(0xFFF5B341),
    warningSoft: Color(0xFF6B4A12),
  );

  @override
  SketchColors copyWith() => this;

  @override
  SketchColors lerp(covariant ThemeExtension<SketchColors>? other, double t) {
    if (other is! SketchColors) return this;
    return t < 0.5 ? this : other;
  }
}

extension SketchColorsX on BuildContext {
  SketchColors get sketch => Theme.of(this).extension<SketchColors>()!;
}
