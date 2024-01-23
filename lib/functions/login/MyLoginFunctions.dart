import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/functions/String/MyStringHandler.dart';
import 'package:shopping_app/pages/MyLoginPage.dart';

import '../../components/login/MyLoginWidget.dart';
import '../../objects/users/MyUsers.dart';
import '../providers/login/MyLoginProvider.dart';
import '../services/firestore/MyFirestoreService.dart';
import '../services/snackbars/MySnackBarService.dart';

///Here are all functions which are contains in [MyLoginPage]
class MyLoginFunctions {

  late BuildContext _context;
  late TextEditingController _prenameController;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late FirebaseAuth _auth;

  MyLoginFunctions (BuildContext context, TextEditingController emailController, TextEditingController passwordController, TextEditingController confirmPasswordController, TextEditingController prenameController, TextEditingController nameController, FirebaseAuth auth) {
    _context = context;
    _emailController = emailController;
    _passwordController = passwordController;
    _confirmPasswordController = confirmPasswordController;
    _prenameController = prenameController;
    _nameController = nameController;
    _auth = auth;
  }

  Future<void> login() async {

    String emailAddress = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (emailAddress == "" || password == "") {
      MySnackBarService.showMySnackBar(_context, 'Es müssen alle Felder mit "*" ausgefüllt werden!');
      return;
    }

    if (!MyStringHandler.isPasswordValid(password)) {
      MySnackBarService.showMySnackBar(_context, 'Das Passwort muss: mindestens 5 Zeichen haben, 1 Zahl, 1 Zeichen!');
      return;
    }

    if (!MyStringHandler.isHTMLValid(emailAddress) || !MyStringHandler.isHTMLValid(password)) {
      MySnackBarService.showMySnackBar(_context, 'Es dürfen nicht diese Zeichen eingegeben werden: < [ ^ > ] * >');
      return;
    }

    try {

      await _auth.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on FirebaseAuthException catch(e) {

      if (e.code == 'user-not-found') {
        MySnackBarService.showMySnackBar(_context, 'Benutzer nicht gefunden.');
      } else if (e.code == 'wrong-password') {
        MySnackBarService.showMySnackBar(_context, 'Falsches Passwort.');
      } else if (e.code == 'user-disabled') {
        MySnackBarService.showMySnackBar(_context, 'Benutzerkonto deaktiviert.');
      } else if (e.code == 'too-many-requests') {
        MySnackBarService.showMySnackBar(_context, 'Zu viele Anfragen. Versuchen Sie es später erneut.');
      } else if (e.code == 'network-request-failed') {
        MySnackBarService.showMySnackBar(_context, 'Netzwerkfehler. Überprüfen Sie Ihre Internetverbindung.');
      } else if (e.code == 'invalid-email') {
        MySnackBarService.showMySnackBar(_context, 'Ungültiges E-Mail-Format. Bitte überprüfen Sie Ihre E-Mail-Adresse.');
      } else if (e.code == 'INVALID_LOGIN_CREDENTIALS' || e.code == 'invalid-credential') {
        MySnackBarService.showMySnackBar(_context, 'E-Mail ist nicht vorhanden oder Passwort ist falsch!');
      } else {
        MySnackBarService.showMySnackBar(_context, 'Ein Fehler ist aufgetreten. Bitte kontaktieren Sie den Support!');
        print("Firebase Error Code: ${e.code}");
      }

    } catch (e) {

      MySnackBarService.showMySnackBar(_context, 'Ein allgemeiner Fehler ist aufgetreten. Bitte kontaktieren Sie den Support!');
    }
  }

  void updateToLoginPage() {

    refreshInputs();

    List<TextEditingController> controllers = [_emailController, _passwordController];

    List<bool> _showPassword = const [false, true];
    List<bool> showPassword = List.generate(controllers.length, (index) => _showPassword.elementAt(index));

    Provider.of<MyLoginProvider>(_context, listen: false).updateShowPasswords(showPassword);

    Provider.of<MyLoginProvider>(_context, listen: false).updateWidget(
        MyLoginWidget(
          title: "Anmeldung",
          buttonFunctions: [login, _toRegister],
          controllers: controllers,
          inputLabels: const ["E-Mail*", "Passwort*"],
          buttonLabels: const ["Anmelden", "Zur Registrierung"],
          buttonForegroundColors: [Colors.white, Theme.of(_context).colorScheme.primary],
          buttonBackgroundColors: [Theme.of(_context).colorScheme.primary,  Colors.white],
          isInputPassword: const [false, true],
          textTypes: const [TextInputType.emailAddress, TextInputType.text],
          maxLengthForTextfields: [-1, -1],
        )
    );
  }

  void updateToRegisterPage() {

    refreshInputs();

    List<TextEditingController> controllers = [_prenameController, _nameController, _emailController, _passwordController, _confirmPasswordController];

    List<bool> _showPassword = const [false, false, false, true, true];
    List<bool> showPassword = List.generate(controllers.length, (index) => _showPassword.elementAt(index));

    Provider.of<MyLoginProvider>(_context, listen: false).updateShowPasswords(showPassword);


    Provider.of<MyLoginProvider>(_context, listen: false).updateWidget(
        MyLoginWidget(
          title: "Registrierung",
          buttonFunctions: [_register, _toLogin],
          controllers: controllers,
          inputLabels: const ["Vorname*", "Nachname*", "E-Mail*", "Passwort*", "Passwort wiederholen*"],
          buttonLabels: const ["Registrieren", "Zur Anmeldung"],
          buttonForegroundColors: [Colors.white, Theme.of(_context).colorScheme.primary],
          buttonBackgroundColors: [Theme.of(_context).colorScheme.primary, Color.lerp(Colors.white, Theme.of(_context).colorScheme.primary, 0.005)!],
          isInputPassword: _showPassword,
          textTypes: const [TextInputType.text, TextInputType.text, TextInputType.emailAddress, TextInputType.text, TextInputType.text],
          maxLengthForTextfields: const [20, 20, -1, -1, -1],
        )
    );
  }

  Future<void> _register() async {

    String emailAddress = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String passwordConfirm = _confirmPasswordController.text.trim();
    String nameOfUser = _nameController.text.trim();
    String prenameOfUser = _prenameController.text.trim();

    if (password == "" || passwordConfirm == "" || prenameOfUser == "" ||
        nameOfUser == "" || emailAddress == "") {
      MySnackBarService.showMySnackBar(_context, 'Es müssen alle Felder mit "*" ausgefüllt werden!');
      return;
    }

    if (!MyStringHandler.isValidEmail(emailAddress)) {
      MySnackBarService.showMySnackBar(_context, 'Es muss eine gültige E-mail-Adresse eingegeben werden.');
      return;
    }

    if (password != passwordConfirm) {
      MySnackBarService.showMySnackBar(_context, 'Die Felder "Passwort" und "Passwort wiederholen" stimmen nicht überein!');
      return;
    }

    if (
    !MyStringHandler.isHTMLValid(emailAddress) ||
        !MyStringHandler.isHTMLValid(password) ||
        !MyStringHandler.isHTMLValid(passwordConfirm) ||
        !MyStringHandler.isHTMLValid(nameOfUser) ||
        !MyStringHandler.isHTMLValid(prenameOfUser)
    ) {
      MySnackBarService.showMySnackBar(_context, 'Es dürfen nicht diese Zeichen eingegeben werden: < >');
      return;
    }

    if (!MyStringHandler.isPasswordValid(password)) {
      MySnackBarService.showMySnackBar(_context, 'Das Passwort muss: mindestens 5 Zeichen haben, 1 Zahl, 1 Sonderzeichen!');
      return;
    }

    if (password != passwordConfirm) {
      MySnackBarService.showMySnackBar(_context, 'Die Felder "Passwort" und "Passwort wiederholen" stimmen nicht überein!');
      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: emailAddress,
          password: password
      );

      String uuid = FirebaseAuth.instance.currentUser!.uid;

      ///create a user in the database, where prename and surname are saved
      MyUser user = MyUser(
          uuid: uuid,
          prename: prenameOfUser,
          surname: nameOfUser,
          groupUUIDs: []
      );
      MyFirestoreService.userService.addUser(user);

      ///Send the email-verification
      userCredential.user!.sendEmailVerification();
      MySnackBarService.showMySnackBar(_context, 'Die Verifizierungs-E-Mail wurde versendet!', isError: false);

    } on FirebaseAuthException catch(e) {

      if (e.code == 'weak-password') {
        MySnackBarService.showMySnackBar(_context, 'Ihr Passwort ist zu schwach!');
      } else if (e.code == 'email-already-in-use') {
        MySnackBarService.showMySnackBar(_context, 'Die eingegebene E-Mail ist bereits vergeben!');
      } else if (e.code == 'invalid-email') {
        MySnackBarService.showMySnackBar(_context, 'Ungültiges E-Mail-Format. Bitte überprüfen Sie Ihre E-Mail-Adresse.');
      } else {
        MySnackBarService.showMySnackBar(_context, 'Ein Fehler ist aufgetreten. Bitte kontaktieren Sie den Support!');
      }

    } catch(e) {

      MySnackBarService.showMySnackBar(_context, 'Ein allgemeiner Fehler ist aufgetreten. Bitte kontaktieren Sie den Support!');
    }
  }

  void _toRegister() async {

    updateToRegisterPage();
  }

  void _toLogin() async {

    updateToLoginPage();
  }

  void refreshInputs() {

    _prenameController.text = "";
    _nameController.text = "";
    _passwordController.text = "";
    _confirmPasswordController.text = "";
    _emailController.text = "";
  }
}