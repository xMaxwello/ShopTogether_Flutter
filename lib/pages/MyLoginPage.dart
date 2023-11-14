import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/components/login/MyLoginWidget.dart';
import 'package:shopping_app/functions/services/firestore/MyFirestoreService.dart';
import 'package:shopping_app/functions/providers/login/MyLoginProvider.dart';
import 'package:shopping_app/functions/services/snackbars/MySnackBarService.dart';
import 'package:shopping_app/objects/users/MyUsers.dart';

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

  void refreshInputs() {

    _prenameController.text = "";
    _nameController.text = "";
    _passwordController.text = "";
    _confirmPasswordController.text = "";
    _emailController.text = "";
  }

  @override
  void initState() {
    super.initState();

    refreshInputs();
  }
 ///TODO: Functionen auslagern in eine Externe Klasse
  void updateToRegisterPage() {

    refreshInputs();

    List<TextEditingController> controllers = [_prenameController, _nameController, _emailController, _passwordController, _confirmPasswordController];

    List<bool> _showPassword = const [false, false, false, true, true];
    List<bool> showPassword = List.generate(controllers.length, (index) => _showPassword.elementAt(index));

    Provider.of<MyLoginProvider>(context, listen: false).updateShowPasswords(showPassword);


    Provider.of<MyLoginProvider>(context, listen: false).updateWidget(
        MyLoginWidget(
          title: "Registrierung",
          buttonFunctions: [_register, _toLogin],
          controllers: controllers,
          inputLabels: const ["Vorname*", "Nachname*", "E-Mail*", "Passwort*", "Passwort wiederholen*"],
          buttonLabels: const ["Registrieren", "Zur Anmeldung"],
          buttonForegroundColors: [Colors.white, Theme.of(context).colorScheme.primary],
          buttonBackgroundColors: [Theme.of(context).colorScheme.primary, Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.005)!],
          isInputPassword: _showPassword,
        )
    );
  }

  void updateToLoginPage() {

    refreshInputs();

    List<TextEditingController> controllers = [_emailController, _passwordController];

    List<bool> _showPassword = const [false, true];
    List<bool> showPassword = List.generate(controllers.length, (index) => _showPassword.elementAt(index));

    Provider.of<MyLoginProvider>(context, listen: false).updateShowPasswords(showPassword);


    Provider.of<MyLoginProvider>(context, listen: false).updateWidget(
        MyLoginWidget(
          title: "Anmeldung",
          buttonFunctions: [_login, _toRegister],
          controllers: controllers,
          inputLabels: const ["E-Mail*", "Passwort*"],
          buttonLabels: const ["Anmelden", "Zur Registrierung"],
          buttonForegroundColors: [Colors.white, Theme.of(context).colorScheme.primary],
          buttonBackgroundColors: [Theme.of(context).colorScheme.primary,  Colors.white],
          isInputPassword: const [false, true],
        )
    );
  }

  void _toRegister() async {

    updateToRegisterPage();
  }

  void _toLogin() async {

    updateToLoginPage();
  }

  Future<void> _login() async {

    bool error = false;

    if (_emailController.text == "" || _passwordController.text == "") {
      MySnackBarService.showMySnackBar(context, 'Es müssen alle Felder mit "*" ausgefüllt werden!');
      error = true;
    }

    if (!error) {

      try {

        await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } on FirebaseAuthException catch(e) {

        if (e.code == 'user-not-found') {
          MySnackBarService.showMySnackBar(context, 'Benutzer nicht gefunden.');
        } else if (e.code == 'wrong-password') {
          MySnackBarService.showMySnackBar(context, 'Falsches Passwort.');
        } else if (e.code == 'user-disabled') {
          MySnackBarService.showMySnackBar(context, 'Benutzerkonto deaktiviert.');
        } else if (e.code == 'too-many-requests') {
          MySnackBarService.showMySnackBar(context, 'Zu viele Anfragen. Versuchen Sie es später erneut.');
        } else if (e.code == 'network-request-failed') {
          MySnackBarService.showMySnackBar(context, 'Netzwerkfehler. Überprüfen Sie Ihre Internetverbindung.');
        } else if (e.code == 'invalid-email') {
          MySnackBarService.showMySnackBar(context, 'Ungültiges E-Mail-Format. Bitte überprüfen Sie Ihre E-Mail-Adresse.');
        } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
          MySnackBarService.showMySnackBar(context, 'E-Mail ist nicht vorhanden oder Passwort ist falsch!');
        } else {
          MySnackBarService.showMySnackBar(context, 'Ein Fehler ist aufgetreten. Bitte kontaktieren Sie den Support!');
          print("Firebase Error Code: ${e.code}");
        }

    } catch (e) {

        MySnackBarService.showMySnackBar(context, 'Ein allgemeiner Fehler ist aufgetreten. Bitte kontaktieren Sie den Support!');
      }
    }
  }

  Future<void> _register() async {

    bool error = false;

    if (_passwordController.text == "" || _confirmPasswordController.text == "" || _prenameController.text == "" ||
        _nameController.text == "" || _emailController.text == "") {
      MySnackBarService.showMySnackBar(context, 'Es müssen alle Felder mit "*" ausgefüllt werden!');
      error = true;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      MySnackBarService.showMySnackBar(context, 'Die Felder "Passwort" und "Passwort wiederholen" stimmen nicht überein!');
      error = true;
    }

    if (!error) {

      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text
        );

        String uuid = FirebaseAuth.instance.currentUser!.uid;

        ///create a user in the database, where prename and surname are saved
        MyUser user = MyUser(
          uuid: uuid,
          prename: _prenameController.text,
          surname: _nameController.text,
          groupUUIDs: []
        );
        MyFirestoreService.addUser(user);

        ///Send the email-verification
        userCredential.user!.sendEmailVerification();
        MySnackBarService.showMySnackBar(context, 'Die Verifizierungs-E-Mail wurde versendet!', isError: false);

      } on FirebaseAuthException catch(e) {

        if (e.code == 'weak-password') {
          MySnackBarService.showMySnackBar(context, 'Ihr Passwort ist zu schwach!');
        } else if (e.code == 'email-already-in-use') {
          MySnackBarService.showMySnackBar(context, 'Die eingegebene E-Mail ist bereits vergeben!');
        } else if (e.code == 'invalid-email') {
          MySnackBarService.showMySnackBar(context, 'Ungültiges E-Mail-Format. Bitte überprüfen Sie Ihre E-Mail-Adresse.');
        } else {
          MySnackBarService.showMySnackBar(context, 'Ein Fehler ist aufgetreten. Bitte kontaktieren Sie den Support!');
        }

      } catch(e) {

        MySnackBarService.showMySnackBar(context, 'Ein allgemeiner Fehler ist aufgetreten. Bitte kontaktieren Sie den Support!');
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
              image: AssetImage('assets/background.png'),
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

                                  updateToLoginPage();
                                }
                              });
                            });

                            return SizedBox(
                              child: value.widget,
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