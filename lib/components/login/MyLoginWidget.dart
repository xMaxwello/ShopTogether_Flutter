import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app/pages/MyRegisterPage.dart';

class MyLoginWidget extends StatelessWidget {

  final Function() loginFunc;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String message;

  const MyLoginWidget({super.key, required this.loginFunc, required this.emailController, required this.passwordController, required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.08),
      child: Padding(
        padding: const EdgeInsets.only(right: 25, left: 25, top: 25, bottom: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [

            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'E-Mail'),
            ),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Passwort'),
              obscureText: true,
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                ElevatedButton(
                    onPressed: loginFunc,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.6)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                      child: Text(
                        'Login',
                        style: GoogleFonts.tiltNeon(
                            fontSize: 19,
                            color: Colors.white
                        ),
                      ),
                    )
                ),

                Text(message),

                ///navigate to register
                ElevatedButton(
                    onPressed: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyRegisterPage()),
                      );

                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.6)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                      child: Text(
                        'Register',
                        style: GoogleFonts.tiltNeon(
                            fontSize: 19,
                            color: Colors.white
                        ),
                      ),
                    )
                ),

              ],
            )

          ],
        ),
      ),
    );
  }
}
