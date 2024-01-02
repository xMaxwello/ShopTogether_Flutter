import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/functions/providers/floatingbutton/MyFloatingButtonProvider.dart';
import 'package:shopping_app/functions/providers/group/MyGroupProvider.dart';
import 'package:shopping_app/functions/providers/login/MyLoginProvider.dart';
import 'package:shopping_app/functions/providers/navigationBar/MyNavigationBarProvider.dart';
import 'package:shopping_app/functions/providers/search/MySearchProvider.dart';
import 'package:shopping_app/functions/providers/settings/MySettingsProvider.dart';
import 'package:shopping_app/functions/services/notification/MyNotificationService.dart';
import 'package:shopping_app/pages/MyEmailVerificationPage.dart';
import 'package:shopping_app/pages/MyLoginPage.dart';
import 'package:shopping_app/themes/DarkTheme.dart';
import 'package:shopping_app/themes/LightTheme.dart';
import 'functions/providers/items/MyItemsProvider.dart';
import 'pages/MyHomePage.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

///TODO: Deutsche Unicode Buchstaben werden nicht als Eingabe anerkannt (z.b ü,ö,ä,ß)

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MyNotificationService.initialize();
  MyNotificationService.requestPermissions();

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Berlin'));
  MyNotificationService.scheduleWeeklyNotification();

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => MyFloatingButtonProvider()),
          ChangeNotifierProvider(create: (context) => MyNavigationBarProvider()),
          ChangeNotifierProvider(create: (context) => MyItemsProvider()),
          ChangeNotifierProvider(create: (context) => MyLoginProvider()),
          ChangeNotifierProvider(create: (context) => MySettingsProvider()),
          ChangeNotifierProvider(create: (context) => MyGroupProvider()),
          ChangeNotifierProvider(create: (context) => MySearchProvider()),
        ],
        child: const MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MySettingsProvider>(
        builder: (context, settingsProvider, child) {
          return MaterialApp(
            title: 'ShopTogether',
            theme: LightTheme.getLightTheme(),

            ///theme class
            darkTheme: DarkTheme.getDarkTheme(),

            ///theme class
            themeMode: settingsProvider.currentThemeMode,

            debugShowCheckedModeBanner: false,
            home: const MyAuthenticationWrapper(),
          );
        }
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

    FirebaseAuth.instance.authStateChanges().listen((User? user) {

        if (user != null) {
          bool isVerified = user.emailVerified;

          if (isVerified) {

            Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage()));
          } else {

            Navigator.push(context, MaterialPageRoute(builder: (context) => const MyEmailVerificationAuthPage()));
          }
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const MyLoginPage()));
        }

    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      )
    );
  }
}