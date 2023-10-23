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
          title: "Registrierung",
          buttonFunctions: [_register, _toLogin],
          controllers: [_prenameController, _nameController, _emailController, _passwordController],
          inputLabels: const ["Vorname*", "Nachname*", "E-Mail*", "Passwort*"],
          buttonLabels: const ["Registrieren", "Zur Anmeldung"],
          buttonForegroundColors: [Colors.white, Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.8)!],
          buttonBackgroundColors: [Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.8)!, Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.005)!],
          isInputPassword: const [false, false, false, true],
        )
    );
  }

  void updateToLoginPage() {

    Provider.of<MyLoginProvider>(context, listen: false).updateWidget(
        MyLoginWidget(
          title: "Anmeldung",
          buttonFunctions: [_login, _toRegister],
          controllers: [_emailController, _passwordController],
          inputLabels: const ["E-Mail*", "Passwort*"],
          buttonLabels: const ["Anmelden", "Zur Registrierung"],
          buttonForegroundColors: [Colors.white, Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.8)!],
          buttonBackgroundColors: [Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.8)!, Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.005)!],
          isInputPassword: const [false, true],
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

    if (_emailController.text == "" || _passwordController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Es müssen alle Felder mit "*" ausgefüllt werden!')));
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
      } on FirebaseAuthException catch(e) {

      } catch (e) {

      }
    }
  }

  Future<void> _register() async {

    //TODO: Verbessern

    bool error = false;

    if (_passwordController.text == "" || _prenameController.text == "" ||
        _nameController.text == "" || _emailController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Es müssen alle Felder mit "*" ausgefüllt werden!')));
      error = true;
    }

    if (!error) {

      try {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text
        );

        //await userCredential.user.sendEmailVerification();
      } on FirebaseAuthException catch(e) {

        if (e.code == 'weak-password') {

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ihr Passwort ist zu schwach!')));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Die eingegebene E-Mail ist bereits vergeben!')));
        }

      } catch(e) {

      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        body: Stack(
          children: [

        Container(
        decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.png'), // Ihr Hintergrundbil
          fit: BoxFit.cover,),),
        ),

            Center(
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
                            fontSize: 40,
                            backgroundColor: Colors.white
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
            ),

          ],
        ),
    );
  }
}