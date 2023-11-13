import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LightTheme {

  static ThemeData getLightTheme () {

    return ThemeData(

      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigoAccent[100]!, error: Colors.red[200]),

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
          foregroundColor: Colors.white, backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
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

      listTileTheme: ListTileThemeData(
        iconColor: Colors.black,
        tileColor: Colors.white24
      ),

      bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.grey[200]
      ),

      cardTheme: CardTheme(
        shadowColor: Colors.black38,
        color: Colors.grey[100],
        elevation: 20,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
        )
      ),

      snackBarTheme: SnackBarThemeData(
        actionTextColor: Colors.white,
        backgroundColor: Colors.indigoAccent[100]
      ),

      searchBarTheme: SearchBarThemeData(
        surfaceTintColor: MaterialStateProperty.all(Colors.indigoAccent[100]),
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
        titleMedium: GoogleFonts.tiltNeon(
            fontSize: 19,
            color: Colors.grey[900]
        ),
        titleLarge: GoogleFonts.tiltNeon(
            fontSize: 24,
            color: Colors.grey[900]
        ),
        displaySmall: GoogleFonts.tiltNeon(
            fontSize: 16,
            color: Colors.black
        ),
        displayLarge: GoogleFonts.tiltNeon(
          fontSize: 40,
          color: Colors.grey[900],
          backgroundColor: Colors.white
        ),
        headlineLarge: GoogleFonts.tiltNeon(
            fontSize: 34,
            color: Colors.black,
            backgroundColor: Colors.white
        ),
      ),

      useMaterial3: true,
    );
  }
}