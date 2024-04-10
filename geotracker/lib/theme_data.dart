import 'package:flutter/material.dart';

ThemeData geotrackerThemeData = ThemeData(
  // scaffoldBackgroundColor: Colors.white,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Colors.grey,
    ),

  ),
  colorScheme: const ColorScheme.light(
    primary: Colors.white,
  ),
  // cardTheme: const CardTheme(
  //   color: Colors.white,
  // ),
  // elevatedButtonTheme: ElevatedButtonThemeData(
  //   style: ButtonStyle(
  //     fixedSize: MaterialStateProperty.all<Size>(const Size(200, 40)),
  //     backgroundColor: MaterialStateProperty.all<Color>(
  //       const Color.fromRGBO(10, 132, 255, 1),
  //     ), // Background Color
  //     padding:
  //         MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(5)), //
  //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
  //       RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10.0), // Round Radius
  //       ),
  //     ),
  //   ),
  // ),
);
