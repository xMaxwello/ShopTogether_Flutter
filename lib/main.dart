import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/functions/providers/floatingbutton/MyFloatingButtonProvider.dart';
import 'package:shopping_app/functions/providers/navigationBar/MyNavigationBarProvider.dart';
import 'package:shopping_app/pages/MyLoginPage.dart';
import 'pages/MyHomePage.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => MyFloatingButtonProvider()),
          ChangeNotifierProvider(create: (context) => MyNavigationBarProvider()),
        ],
        child: const MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Shoppinglist',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthenticationWrapper(),
    );
  }
}


class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {


    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {

          return const CircularProgressIndicator(); //if its loading
        } else {

          if (snapshot.hasData) {

            return const MyHomePage(); //the user is logged in
          } else {

            return const MyLoginPage(); //the user is logged out
          }
        }
      },
    );
  }
}
