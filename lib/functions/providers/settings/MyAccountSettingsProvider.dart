import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../snackbars/MySnackBar.dart';

class MyAccountSettingsProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> updateEmail(BuildContext context, String newEmail, String password) async {
    if (newEmail.isEmpty || password.isEmpty) {
      MySnackBar.showMySnackBar(context, 'Bitte füllen Sie alle Felder aus.', backgroundColor: Colors.blueGrey);
      return;
    }

    User? user = _auth.currentUser;
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updateEmail(newEmail);
      MySnackBar.showMySnackBar(context, 'Die E-Mail wurde erfolgreich geändert.', backgroundColor: Colors.blueGrey);
    } on FirebaseAuthException catch (e) {
      MySnackBar.showMySnackBar(context, 'Fehler: ${e.message}', backgroundColor: Colors.red);
    }
  }

  Future<void> updatePassword(BuildContext context, String oldPassword, String newPassword, String repeatNewPassword) async {
    if (oldPassword.isEmpty || newPassword.isEmpty || repeatNewPassword.isEmpty) {
      MySnackBar.showMySnackBar(context, 'Bitte füllen Sie alle Felder aus.', backgroundColor: Colors.red);
      return;
    }

    if (newPassword != repeatNewPassword) {
      MySnackBar.showMySnackBar(context, 'Die neuen Passwörter stimmen nicht überein.', backgroundColor: Colors.red);
      return;
    }

    User? user = _auth.currentUser;

    AuthCredential credential = EmailAuthProvider.credential(
      email: user!.email!,
      password: oldPassword,
    );

    try {
      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPassword);
      MySnackBar.showMySnackBar(context, 'Das Passwort wurde erfolgreich geändert.', backgroundColor: Colors.blueGrey);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        MySnackBar.showMySnackBar(context, 'Das alte Passwort ist nicht korrekt.');
      } else {
        MySnackBar.showMySnackBar(context, 'Ein Fehler ist aufgetreten. Bitte versuchen Sie es später noch einmal.');
      }
    }
  }

  Future<void> deleteAccount(BuildContext context) async {
    User? user = _auth.currentUser;
    try {
      await user?.delete();
      MySnackBar.showMySnackBar(context, 'Ihr Account wurde erfolgreich gelöscht.', backgroundColor: Colors.blueGrey);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      MySnackBar.showMySnackBar(context, 'Es ist ein Fehler aufgetreten. Bitte versuchen Sie es später noch einmal.');
    }
  }
}
