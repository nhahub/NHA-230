import 'package:flutter/material.dart';

class ThemeState {
  final bool isDark;
  final ThemeMode themeMode;

  const ThemeState({required this.isDark})
      : themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

  ThemeState copyWith({bool? isDark}) {
    return ThemeState(isDark: isDark ?? this.isDark);
  }

  @override
  String toString() => 'ThemeState(isDark: $isDark)';
}
