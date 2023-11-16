import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DarkTheme {

  static ThemeData getDarkTheme() {

    return ThemeData(

      colorScheme: ColorScheme.fromSeed(
        background: const Color(0xff2b2b2b),
          seedColor: Colors.indigoAccent[100]!,
          error: Colors.red[200]
      ),

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

      listTileTheme: const ListTileThemeData(
          iconColor: Colors.black,
          tileColor: Color(0xff2b2b2b)
      ),

      bottomAppBarTheme: const BottomAppBarTheme(
          color: Color(0xff3c3f41)
      ),

      cardTheme: const CardTheme(
          shadowColor: Colors.black38,
          color: Color(0xff3c3f41),
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topRight: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
          )
      ),

      snackBarTheme: SnackBarThemeData(
          actionTextColor: Colors.white,
          backgroundColor: Colors.indigoAccent[100]
      ),

      dividerTheme: const DividerThemeData(
          color: Colors.white60
      ),

      searchBarTheme: SearchBarThemeData( ///TODO: Würde ich etwas dunkler machen, damit das mit den ProductAddItem etwas besser passt
        surfaceTintColor: MaterialStateProperty.all(const Color(0xff555555)),
      ),

      iconTheme: const IconThemeData(
          size: 26,
          color: Color(0xff959595)
      ),

      textTheme: TextTheme(
        labelMedium: GoogleFonts.tiltNeon(
            fontSize: 19,
            color: Colors.white
        ),
        labelSmall: GoogleFonts.tiltNeon(
            fontSize: 16,
            color: const Color(0xff959595)
        ),
        bodySmall: GoogleFonts.tiltNeon(
            fontSize: 16,
            color: const Color(0xff959595)
        ),
        bodyMedium: GoogleFonts.tiltNeon(
          fontSize: 20,
          color: const Color(0xff959595)
        ),
        titleSmall: GoogleFonts.tiltNeon(
            fontSize: 14,
            color: Colors.white
        ),
        titleMedium: GoogleFonts.tiltNeon(
            fontSize: 19,
            color: Colors.white
        ),
        titleLarge: GoogleFonts.tiltNeon(
            fontSize: 24,
            color: Colors.white
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
            color: Colors.white,
        ),
      ),

      useMaterial3: true,
    );
  }
}