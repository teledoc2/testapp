
import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  primaryColor: Color(0xFF38488F),
  scaffoldBackgroundColor: Color(0xFFF0F0F2),
  backgroundColor: Color(0xFFFDFDFF),
  fontFamily: 'Segoe UI',
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    headlineMedium: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    headlineSmall: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    bodyLarge: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    bodyMedium: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    bodySmall: TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF38488F),
    elevation: 0,
    titleTextStyle: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: Color(0xFF38488F),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      primary: Color(0xFF38488F),
      textStyle: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      primary: Color(0xFF38488F),
      side: BorderSide(color: Color(0xFF38488F)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    filled: true,
    fillColor: Color(0xFFFDFDFF),
    focusColor: Color(0xFF38488F),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF38488F)),
      borderRadius: BorderRadius.circular(8.0),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
  cardTheme: CardTheme(
    color: Color(0xFFFDFDFF),
    elevation: 2,
    margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
);
