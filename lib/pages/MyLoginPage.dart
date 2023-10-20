import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/components/login/MyLoginWidget.dart';
import 'package:shopping_app/functions/providers/login/MyLoginProvider.dart';
import 'package:shopping_app/pages/MyHomePage.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _prenameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  void updateToRegisterPage() {

    Provider.of<MyLoginProvider>(context, listen: false).updateWidget(
        MyLoginWidget(
            buttonFunctions: [_register, _toLogin],
            controllers: [_prenameController, _nameController, _emailController, _passwordController],
            inputLabels: const ["Vorname*", "Nachname*", "E-Mail*", "Passwort*"],
            buttonLabels: const ["Registrieren", "Zum Login"],
            buttonForegroundColors: [Colors.white, Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.8)!],
            buttonBackgroundColors: [Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.8)!, Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.005)!]
        )
    );
  }

  void updateToLoginPage() {

    Provider.of<MyLoginProvider>(context, listen: false).updateWidget(
        MyLoginWidget(
            buttonFunctions: [_login, _toRegister],
            controllers: [_emailController, _passwordController],
            inputLabels: const ["E-Mail*", "Passwort*"],
            buttonLabels: const ["Anmelden", "Zur Registrierung"],
            buttonForegroundColors: [Colors.white, Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.8)!],
            buttonBackgroundColors: [Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.8)!, Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.005)!]
        )
    );
  }

  void _toRegister() {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {

        updateToRegisterPage();
      });
    });

  }

  void _toLogin() {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {

          updateToLoginPage();
      });
    });
  }

  Future<void> _login() async {

    bool error = false;

    if (_emailController.text == "") {
      Provider.of<MyLoginProvider>(context, listen: false)
          .updateMessage("Geben Sie die E-Mail ein!");
      error = true;
    }

    if (_passwordController.text == "") {
      Provider.of<MyLoginProvider>(context, listen: false)
          .updateMessage("Geben Sie das Passwort ein!");
      error = true;
    }

    if (!error) {

      try {
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        Navigator.push(context,
          MaterialPageRoute(builder: (context) => MyHomePage()));
      } catch (e) {
        Provider.of<MyLoginProvider>(context, listen: false)
            .updateMessage("Ein Fehler ist aufgetreten!");
      }
    }
  }

  Future<void> _register() async {

    ///TODO: register fertig machen
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Text(
                      "Einkaufsapp",
                      style: GoogleFonts.tiltNeon(
                          fontSize: 40
                      ),
                    ),
                    const SizedBox(height: 60,),

                    Consumer<MyLoginProvider>(
                        builder: (BuildContext context,
                        MyLoginProvider value,
                        Widget? child) {

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {

                              if (value.widget == null) {

                                updateToLoginPage();
                              }
                            });
                          });

                          return AnimatedSwitcher(
                            switchInCurve: Curves.fastOutSlowIn,
                            duration: const Duration(milliseconds: 500),
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(-1, 0), // Startposition von links außerhalb des Bildschirms
                                end: const Offset(0, 0),   // Aktuelle Position des Elements
                              ).animate(CurvedAnimation(
                                parent: const AlwaysStoppedAnimation(1.0),
                                curve: Curves.fastOutSlowIn,
                              )),
                              child: value.widget,
                            ),
                          );
                        }),

                    const SizedBox(height: 60,)

                  ],
                ),
              ),
            ),
        )
    );
  }
}