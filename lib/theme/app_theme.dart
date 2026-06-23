import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:evora/theme/sketch_colors.dart';

/// App-wide theme mode. Settings writes it; [MaterialApp] listens to it.
final themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);

TextTheme _textTheme(TextTheme base, SketchColors c) {
  final body = GoogleFonts.nunitoTextTheme(base);
  TextStyle hand(TextStyle? s) => GoogleFonts.patrickHand(textStyle: s);
  return body
      .copyWith(
        displayLarge: hand(body.displayLarge),
        displayMedium: hand(body.displayMedium),
        displaySmall: hand(body.displaySmall),
        headlineLarge: hand(body.headlineLarge),
        headlineMedium: hand(body.headlineMedium),
        headlineSmall: hand(body.headlineSmall),
      )
      .apply(bodyColor: c.body, displayColor: c.heading);
}

ColorScheme _scheme(SketchColors c, Brightness brightness) => ColorScheme(
      brightness: brightness,
      primary: c.brand,
      onPrimary: Colors.white,
      primaryContainer: c.brandSofter,
      onPrimaryContainer: c.brandStrong,
      secondary: c.brand,
      onSecondary: Colors.white,
      error: c.danger,
      onError: Colors.white,
      surface: c.canvas,
      onSurface: c.heading,
      surfaceContainerLowest: c.canvas,
      surfaceContainerLow: c.paperSoft,
      surfaceContainer: c.paper,
      surfaceContainerHigh: c.paper,
      surfaceContainerHighest: c.paperSoft,
      onSurfaceVariant: c.bodySubtle,
      outline: c.borderDefault,
      outlineVariant: c.borderDefault,
    );

ThemeData _build(SketchColors c, Brightness brightness) {
  final scheme = _scheme(c, brightness);
  final base = ThemeData(useMaterial3: true, colorScheme: scheme);
  final text = _textTheme(base.textTheme, c);

  OutlineInputBorder field(Color color, double width) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: BorderSide(color: color, width: width),
      );

  return base.copyWith(
    scaffoldBackgroundColor: c.canvas,
    textTheme: text,
    extensions: [c],
    appBarTheme: AppBarTheme(
      backgroundColor: c.canvas,
      foregroundColor: c.heading,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: text.headlineSmall,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: c.paperSoft,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      hintStyle: TextStyle(color: c.bodySubtle),
      labelStyle: TextStyle(color: c.bodySubtle),
      prefixIconColor: c.body,
      suffixIconColor: c.body,
      border: field(c.borderDefaultMedium, 2),
      enabledBorder: field(c.borderDefaultMedium, 2),
      focusedBorder: field(c.brand, 2),
      errorBorder: field(c.danger, 2),
      focusedErrorBorder: field(c.danger, 2),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: c.brandStrong),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: c.paper,
      indicatorColor: c.brandSofter,
      elevation: 0,
      height: 68,
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: c.body),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected) ? c.brandStrong : c.bodySubtle,
        ),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: c.paperSoft,
      shape: const StadiumBorder(),
      side: BorderSide(color: c.borderDefault, width: 2),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: c.ink,
      contentTextStyle: const TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

ThemeData lightTheme() => _build(SketchColors.light, Brightness.light);
ThemeData darkTheme() => _build(SketchColors.dark, Brightness.dark);
