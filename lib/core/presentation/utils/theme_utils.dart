import 'package:flutter/material.dart';

extension ThemeColorsExtension on BuildContext {

  Color get surfaceColor => Theme.of(this).colorScheme.surface;
  Color get onSurfaceColor => Theme.of(this).colorScheme.onSurface;
  Color get primaryColor => Theme.of(this).colorScheme.primary;
  Color get onPrimaryColor => Theme.of(this).colorScheme.onPrimary;
  Color get secondaryColor => Theme.of(this).colorScheme.secondary;
  Color get onSecondaryColor => Theme.of(this).colorScheme.onSecondary;
  Color get errorColor => Theme.of(this).colorScheme.error;
  Color get onErrorColor => Theme.of(this).colorScheme.onError;
  Brightness get brightness => Theme.of(this).brightness;
}

