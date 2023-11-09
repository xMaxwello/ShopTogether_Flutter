import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LightTheme {

  static ThemeData getLightTheme () {

    return ThemeData(

      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigoAccent[100]!),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
        extendedTextStyle: GoogleFonts.tiltNeon(
          color: Colors.white,
          fontSize: 18
        ),
        iconSize: 26,
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Colors.blue, // Hintergrundfarbe
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24), // Innenabstand
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Randradius
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.indigoAccent),
          minimumSize: MaterialStateProperty.resolveWith<Size?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return const Size(200, 50);
              }
              return const Size(180, 40);
            },
          ),
        )
      ),

      bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.grey[200]
      ),

      cardTheme: const CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          side: BorderSide(strokeAlign: BorderSide.strokeAlignCenter, color: Colors.indigoAccent)
        )
      ),

      iconTheme: IconThemeData(
        size: 26,
        color: Colors.grey[800]
      ),

      textTheme: TextTheme(
        labelMedium: GoogleFonts.tiltNeon(
          fontSize: 19,
          color: Colors.white
        ),
        labelSmall: GoogleFonts.tiltNeon(
            fontSize: 16,
            color: Colors.white
        ),
        bodySmall: GoogleFonts.tiltNeon(
            fontSize: 16,
            color: Colors.grey[600]
        ),
        titleSmall: GoogleFonts.tiltNeon(
            fontSize: 14,
            color: Colors.grey[900]
        ),
      ),

      useMaterial3: true,
    );
  }
}