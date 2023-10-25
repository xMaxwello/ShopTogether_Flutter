import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/functions/providers/floatingbutton/MyFloatingButtonProvider.dart';
import 'package:shopping_app/functions/providers/login/MyLoginProvider.dart';
import 'package:shopping_app/functions/providers/navigationBar/MyNavigationBarProvider.dart';
import 'package:shopping_app/functions/providers/settings/MySettingsProvider.dart';
import 'package:shopping_app/pages/MyEmailVerificationPage.dart';
import 'package:shopping_app/pages/MyLoginPage.dart';
import 'functions/providers/items/MyItemsProvider.dart';
import 'pages/MyHomePage.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => MyFloatingButtonProvider()),
          ChangeNotifierProvider(create: (context) => MyNavigationBarProvider()),
          ChangeNotifierProvider(create: (context) => MyItemsProvider()),
          ChangeNotifierProvider(create: (context) => MyLoginProvider()),
          ChangeNotifierProvider(create: (context) => MySettingsProvider()),
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyAuthenticationWrapper(),
    );
  }
}

class MyAuthenticationWrapper extends StatefulWidget {
  const MyAuthenticationWrapper({super.key});

  @override
  State<MyAuthenticationWrapper> createState() => _MyAuthenticationWrapperState();
}

class _MyAuthenticationWrapperState extends State<MyAuthenticationWrapper> {
  @override
  Widget build(BuildContext context) {


    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {

          if (snapshot.hasData) {
            bool isVerified = snapshot.data!.emailVerified;

            if (isVerified) {

              return const MyHomePage();
            } else {

              return const MyEmailVerificationPage();
            }
          } else {
            return const MyLoginPage();
          }
        }
      },
    );
  }
}
