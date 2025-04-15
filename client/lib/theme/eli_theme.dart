import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class EliTheme {
  // The FlexColorScheme defined light mode ThemeData.
  static ThemeData light = FlexThemeData.light(
    // User defined custom colors made with FlexSchemeColor() API.
    colors: const FlexSchemeColor(
      primary: Color(0xff031f49),
      // primaryContainer: Color(0xFFD0E4FF),
      secondary: Color(0xFF20a466),
      // secondaryContainer: Color(0xFFFFDBCF),
      tertiary: Color(0xFFf8f8f8),
      // tertiaryContainer: Color(0xFF95F0FF),
      // appBarColor: Color(0xFFFFDBCF),
      // error: Color(0xFFBA1A1A),
      // errorContainer: Color(0xFFFFDAD6),
    ),
    // Component theme configurations for light mode.
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
    ),
    // Direct ThemeData properties.
    textTheme: GoogleFonts.poppinsTextTheme(),

    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );

  // The FlexColorScheme defined dark mode ThemeData.
  static ThemeData dark = FlexThemeData.dark(
    // User defined custom colors made with FlexSchemeColor() API.
    colors: const FlexSchemeColor(
      primary: Color(0xFFf8f8f8),
      // primaryContainer: Color(0xFFD0E4FF),
      secondary: Color(0xFF20a466),
      // secondaryContainer: Color(0xFFFFDBCF),
      // tertiaryContainer: Color(0xFF95F0FF),
      tertiary: Color(0xff031f49),
      // appBarColor: Color(0xFFFFDBCF),
      // error: Color(0xFFBA1A1A),
      // errorContainer: Color(0xFFFFDAD6),
    ),
    // Component theme configurations for dark mode.
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}
