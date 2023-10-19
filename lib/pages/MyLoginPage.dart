import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app/components/login/MyLoginWidget.dart';
import 'package:shopping_app/pages/MyHomePage.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {

  String message = "";

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {

    bool error = false;

    if (_emailController.text == "") {
      message = "Bitte geben Sie Ihre Email ein!";
      error = true;
    }

    if (_passwordController.text == "") {
      message = "Bitte geben Sie Ihre Password ein!";
      error = true;
    }

    if (!error) {

      try {
        final UserCredential userCredential = await _auth
            .signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        final User? user = userCredential.user;
        print(user!.email);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      } catch (e) {
        print("Error");
        message = "Bitte geben Sie Ihre Email ein!";
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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

                  MyLoginWidget(
                    loginFunc: _login,
                    message: message,
                    emailController: _emailController,
                    passwordController: _passwordController,
                  ),

                  const SizedBox(height: 60,)

                ],
              )
            ),
        )
    );
  }
}