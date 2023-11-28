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
        MySnackBarService.showMySnackBar(context, "Ihre E-Mail wurde verifiziert!", isError: false);
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

    return Consumer<MySettingsProvider>(
        builder: (BuildContext context, MySettingsProvider mySettingsProvider, Widget? child) {

          String getBackgroundImage() {
            return mySettingsProvider.isDarkThemeEnabled
                ? 'assets/background_dark.png'
                : 'assets/background.png';
          }

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
                            style: Theme.of(context).textTheme.titleLarge,
                          ),

                          const SizedBox(height: 30,),
                          Text(
                            "Bevor Sie die App benutzen können, müssen\n Sie Ihre E-Mail Adresse verifizieren!",
                            style: Theme.of(context).textTheme.titleMedium,
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
                                style: Theme.of(context).textTheme.labelMedium
                            ),
                          ),

                          ElevatedButton(
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                            },
                            child: Text(
                                "Abbruch",
                                style: Theme.of(context).textTheme.labelMedium
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
}