import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/functions/providers/settings/MySettingsProvider.dart';

import '../functions/services/snackbars/MySnackBarService.dart';
import 'MyHomePage.dart';

class MyEmailVerificationAuthPage extends StatefulWidget {
  const MyEmailVerificationAuthPage({super.key});

  @override
  State<MyEmailVerificationAuthPage> createState() => _MyEmailVerificationAuthPageState();
}

class _MyEmailVerificationAuthPageState extends State<MyEmailVerificationAuthPage> {

  int counter = 0;

  Stream<bool> checkUserVerified() async* {
    bool verified = false;
    while (!verified) {
      User? user = FirebaseAuth.instance.currentUser;
      if(user != null) await user.reload();
      if (user == null) {
        yield false;
      } else {
        await user.reload();
        bool verified = user.emailVerified;
        if (verified && counter == 0) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage()));
          //MySnackBarService.showMySnackBar(context, "Ihre E-Mail wurde verifiziert!", isError: false);
          counter = 1;
        }
        yield verified;
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<MySettingsProvider>(
        builder: (BuildContext context, MySettingsProvider mySettingsProvider, Widget? child) {

          String getBackgroundImage() {
            return mySettingsProvider.isDarkThemeEnabled
                ? 'assets/background_dark.png'
                : 'assets/background.png';
          }

          return StreamBuilder<bool>(
              stream: checkUserVerified(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                //requires-recent-login

                return Scaffold(
                  body: Stack(
                    children: [

                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(getBackgroundImage()),
                            fit: BoxFit.cover,),),
                      ),

                      Center(
                        child: Card(
                          color: Theme.of(context).cardTheme.color,
                          elevation: 20,
                          clipBehavior: Clip.antiAlias,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0),
                                topLeft: Radius.circular(20.0),
                                bottomLeft: Radius.circular(20.0)
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(25),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Text(
                                  "E-Mail Adresse verifizieren",
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),

                                const SizedBox(height: 30,),
                                Text(
                                  "Bevor Sie die App benutzen können, müssen\n Sie Ihre E-Mail Adresse verifizieren!",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                ),

                                const SizedBox(height: 20,),

                                ElevatedButton(
                                  onPressed: () async {

                                    User? user = FirebaseAuth.instance.currentUser;

                                    if (user != null) {

                                      await user.sendEmailVerification();
                                      MySnackBarService.showMySnackBar(context, 'Die Verifizierungs-E-Mail wurde versendet!', isError: false,);
                                    } else {
                                      MySnackBarService.showMySnackBar(context, 'Sie sind nicht angemeldet!');
                                    }
                                  },
                                  child: Text(
                                      "E-Mail erneut senden",
                                      style: Theme.of(context).textTheme.displaySmall
                                  ),
                                ),

                                ElevatedButton(
                                  onPressed: () async {
                                    await FirebaseAuth.instance.signOut();
                                  },
                                  child: Text(
                                      "Abbruch",
                                      style: Theme.of(context).textTheme.displaySmall
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
          );
        }
    );
  }
}