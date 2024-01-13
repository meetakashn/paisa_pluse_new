import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Mytheme {
  static ThemeData lighttheme(BuildContext context) => ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.lato().fontFamily,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black87),
          toolbarTextStyle: Theme.of(context).textTheme.bodyText1,
          titleTextStyle: Theme.of(context).textTheme.headline6,
        ),
      );

  static ThemeData darktheme(BuildContext context) => ThemeData(
        brightness: Brightness.dark,
      );
}
