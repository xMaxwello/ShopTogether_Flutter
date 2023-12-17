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
          iconColor: Color(0xff959595),
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

      searchBarTheme: SearchBarThemeData(
        backgroundColor: MaterialStateProperty.all(Colors.grey.shade800),
        surfaceTintColor: MaterialStateProperty.all(Colors.grey.shade600)
      ),

      searchViewTheme: SearchViewThemeData(
        backgroundColor: Colors.grey.shade800,
        surfaceTintColor: Colors.grey.shade800
      ),

      iconTheme: const IconThemeData(
          size: 26,
          color: Color(0xff959595)
      ),

      textTheme: TextTheme(

        //Text für leere Pages, Settingsparameter, Dialogtext
        labelSmall: GoogleFonts.tiltNeon(
            fontSize: 14,
            color: const Color(0xff959595)
        ),

        //Font für Hinttext im Eingabefeld
        labelMedium: GoogleFonts.tiltNeon(
            fontSize: 16,
            color: const Color(0xff959595)
        ),

        //Textabschnitte allgemein (ItemBottomSheet)
        bodySmall: GoogleFonts.tiltNeon(
            fontSize: 14,
            color: Colors.white
        ),

        //Font für Eingaben in Textfelder, Text in Verification Card
        bodyMedium: GoogleFonts.tiltNeon(
          fontSize: 16,
          color: Colors.white
        ),

        //Überschrift der Produkt-/Gruppen-/User Tiles
        titleSmall: GoogleFonts.tiltNeon(
            fontSize: 19,
            color: Colors.white
        ),

        //Überschrift der Cards, Dialogtitel
        titleMedium: GoogleFonts.tiltNeon(
            fontSize: 24,
            color: Colors.white
        ),

        //Überschrift der Pages, Login/Registration Cards
        titleLarge: GoogleFonts.tiltNeon(
            fontSize: 34,
            color: Colors.white
        ),

        //Buttonfont
        displaySmall: GoogleFonts.tiltNeon(
            fontSize: 16,
            color: Colors.white
        ),

        //Buttonfont for Buttons with no background
        displayMedium: GoogleFonts.tiltNeon(
            fontSize: 16,
            color: Colors.indigo[400]
        ),

        //Überschrift der Anmeldeseite
        headlineLarge: GoogleFonts.tiltNeon(
          fontSize: 40,
          color: Colors.white,
          backgroundColor: Colors.black,
        ),
      ),

      useMaterial3: true,
    );
  }
}