import 'package:flutter/material.dart';

class WidgetsThemeData {
  final Color primaryColor;
  WidgetsThemeData({required this.primaryColor})
      : textButtonTheme = TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: primaryColor),
        ),
        outlinedButtonTheme = OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            fixedSize: const Size(380, 56),
            padding: const EdgeInsets.all(12),
            side: BorderSide(width: 1.5, color: primaryColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );

  final TextButtonThemeData textButtonTheme;
  final OutlinedButtonThemeData outlinedButtonTheme;

  final appBarTheme = const AppBarTheme(
    elevation: 0,
    centerTitle: true,
    foregroundColor: Colors.black,
    backgroundColor: Colors.white,
  );

  final inputDecorationTheme = const InputDecorationTheme(
    filled: true,
    fillColor: Color(0xffF1F1F1),
    hintStyle: TextStyle(color: Colors.grey, height: 1.2),
    errorStyle: TextStyle(fontSize: 14, color: Color.fromARGB(255, 241, 0, 0)),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: Color.fromARGB(255, 226, 224, 224)),
    ),
    contentPadding: EdgeInsets.all(24),
  );
}
