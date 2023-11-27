import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/functions/others/MyLoginFunctions.dart';
import 'package:shopping_app/functions/providers/login/MyLoginProvider.dart';
import 'package:shopping_app/functions/services/biometricsLogin/MyBiometricsLogin.dart';

import '../functions/providers/settings/MySettingsProvider.dart';
import '../functions/services/storage/MyStorageKeys.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _prenameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  late MyLoginFunctions myLoginFunctions;

  @override
  void initState() {
    super.initState();

    myLoginFunctions = MyLoginFunctions(context, _emailController, _passwordController, _confirmPasswordController, _prenameController, _nameController, _auth);
    myLoginFunctions.refreshInputs();
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
                            style: Theme.of(context).textTheme.displayLarge
                          ),
                          const SizedBox(height: 60,),

                          Consumer<MyLoginProvider>(
                              builder: (BuildContext context,
                                  MyLoginProvider value,
                                  Widget? child) {

                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  setState(() {

                                    if (value.widget == null) {

                                      myLoginFunctions.updateToLoginPage();
                                    }
                                  });
                                });

                                return SizedBox(
                                  child: value.widget,
                                );
                              }),

                          const SizedBox(height: 60,),

                          ///TODO: Gucken
                          mySettingsProvider.isBiometricLock ?
                          FloatingActionButton.extended(
                            onPressed: () async {
                              MyBiometricsLogin.loginWithBiometrics(context);
                            },
                            backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
                            foregroundColor: Theme.of(context).floatingActionButtonTheme.foregroundColor,
                            label: Icon(
                              Icons.fingerprint,
                              color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
                              size: Theme.of(context).floatingActionButtonTheme.iconSize,
                            ),
                          )
                          :
                          const SizedBox(),

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}