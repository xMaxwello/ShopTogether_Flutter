import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../functions/snackbars/MySnackBar.dart';
import 'MyHomePage.dart';

class MyEmailVerificationAuthPage extends StatefulWidget {
  const MyEmailVerificationAuthPage({super.key});

  @override
  State<MyEmailVerificationAuthPage> createState() => _MyEmailVerificationAuthPageState();
}

class _MyEmailVerificationAuthPageState extends State<MyEmailVerificationAuthPage> {

  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        timer.cancel();

        Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage()));
        MySnackBar.showMySnackBar(context, "Ihre E-Mail wurde verifiziert!", backgroundColor: Colors.blueGrey);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [

          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,),),
          ),

          Center(
            child: Card(
              color: Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.08),
              elevation: 20,
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text(
                      "E-Mail Adresse verifizieren",
                      style: GoogleFonts.tiltNeon(
                          fontSize: 24
                      ),
                    ),

                    const SizedBox(height: 30,),
                    Text(
                      "Bevor Sie die App benutzen können, müssen\n Sie Ihre E-Mail Adresse verifizieren!",
                      style: GoogleFonts.tiltNeon(
                        fontSize: 16,
                      ),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20,),

                    ElevatedButton(
                      onPressed: () async {

                        User? user = FirebaseAuth.instance.currentUser;

                        if (user != null) {

                          await user.sendEmailVerification();
                          MySnackBar.showMySnackBar(context, 'Die Verifizierungs-E-Mail wurde versendet!', backgroundColor: Colors.black38);
                        } else {
                          MySnackBar.showMySnackBar(context, 'Sie sind nicht angemeldet!');
                        }
                      },
                      child: Text(
                        "E-Mail erneut senden",
                        style: GoogleFonts.tiltNeon(
                            fontSize: 20
                        ),
                      ),
                    ),

                    ElevatedButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                      },
                      child: Text(
                        "Abbruch",
                        style: GoogleFonts.tiltNeon(
                            fontSize: 20
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}