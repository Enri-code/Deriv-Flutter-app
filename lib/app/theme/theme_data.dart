import 'package:deriv_test/app/theme/widgets_theme.dart';
import 'package:flutter/material.dart';

class ThemeBuilder {
  ThemeBuilder({Color primaryColor = Colors.blue, bool isDarkTheme = false}) {
    widgetsTheme = WidgetsThemeData(primaryColor);
    theme = ThemeData.from(
      colorScheme: isDarkTheme
          ? ColorScheme.dark(primary: primaryColor)
          : ColorScheme.light(primary: primaryColor),
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
