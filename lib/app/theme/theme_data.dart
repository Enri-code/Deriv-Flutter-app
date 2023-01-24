import 'package:deriv_test/app/theme/widgets_theme.dart';
import 'package:flutter/material.dart';

class LightThemeData {
  final Color primaryColor;
  LightThemeData(this.primaryColor) {
    widgetsTheme = WidgetsThemeData(primaryColor: primaryColor);
    theme = ThemeData.from(
      colorScheme: ColorScheme.light(primary: primaryColor),
    ).copyWith(
      visualDensity: VisualDensity.compact,
      appBarTheme: widgetsTheme.appBarTheme,
      textButtonTheme: widgetsTheme.textButtonTheme,
      outlinedButtonTheme: widgetsTheme.outlinedButtonTheme,
      inputDecorationTheme: widgetsTheme.inputDecorationTheme,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  late final ThemeData theme;
  late final WidgetsThemeData widgetsTheme;
}
