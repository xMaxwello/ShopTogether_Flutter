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

      listTileTheme: const ListTileThemeData(
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

      dividerTheme: const DividerThemeData(
        color: Colors.black54
      ),

      textTheme: TextTheme(

        //Text für leere Pages, Settingsparameter, Dialogtext
        labelSmall: GoogleFonts.tiltNeon(
            fontSize: 14,
            color: Colors.grey[600]
        ),

        //Font für Hinttext im Eingabefeld
        labelMedium: GoogleFonts.tiltNeon(
          fontSize: 16,
          color: Colors.grey[600]
        ),

        //Textabschnitte allgemein (ItemBottomSheet)
        bodySmall: GoogleFonts.tiltNeon(
            fontSize: 14,
            color: Colors.black

        ),
        //Font für Eingaben in Textfelder, Text in Verification Card
        bodyMedium: GoogleFonts.tiltNeon(
          fontSize: 16,
          color: Colors.black
        ),

        //Überschrift der Produkt-/Gruppen-/User Tiles
        titleSmall: GoogleFonts.tiltNeon(
            fontSize: 19,
            color: Colors.black
        ),

        //Überschrift der Cards, Dialogtitel
        titleMedium: GoogleFonts.tiltNeon(
            fontSize: 24,
            color: Colors.black
        ),

        //Überschrift der Pages, Login/Registration Cards
        titleLarge: GoogleFonts.tiltNeon(
            fontSize: 34,
            color: Colors.black
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
          color: Colors.black,
          backgroundColor: Colors.white,
        ),
      ),

      useMaterial3: true,
    );
  }
}