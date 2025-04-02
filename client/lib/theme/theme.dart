// Theme config for FlexColorScheme version 7.2.x. Make sure you use
// same or higher package version, but still same major version. If you
// use a lower package version, some properties may not be supported.
// In that case remove them after copying this theme to your app.
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = FlexThemeData.light(
  scheme: FlexScheme.shark,
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 7,
  textTheme: GoogleFonts.ralewayTextTheme(),
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 10,
    blendOnColors: false,
    useMaterial3Typography: true,
    useM2StyleDividerInM3: true,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
);
final darkTheme = FlexThemeData.dark(
  textTheme: GoogleFonts.ralewayTextTheme(),
  scheme: FlexScheme.shark,
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 13,
  subThemesData: const FlexSubThemesData(blendOnLevel: 20, useMaterial3Typography: true, useM2StyleDividerInM3: true),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
);
