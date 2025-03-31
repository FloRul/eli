import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
class ThemeModeNotif extends _$ThemeModeNotif {
  @override
  ThemeMode build() => ThemeMode.dark;

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }
}
