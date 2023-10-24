import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyEmailVerificationPage extends StatelessWidget {
  const MyEmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {

    void sendVerificationEmail() async {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
    }

    void cancelVerification() async {
      await FirebaseAuth.instance.signOut();
    }

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
                        onPressed: sendVerificationEmail,
                        child: Text(
                            "E-Mail erneut senden",
                          style: GoogleFonts.tiltNeon(
                              fontSize: 20
                          ),
                        ),
                    ),

                    ElevatedButton(
                      onPressed: cancelVerification,
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
