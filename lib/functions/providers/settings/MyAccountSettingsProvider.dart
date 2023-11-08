import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../snackbars/MySnackBar.dart';

class MyAccountSettingsProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> updateEmail(BuildContext context, String newEmail) async {
    User? user = _auth.currentUser;
    try {
      await user?.updateEmail(newEmail);
      MySnackBar.showMySnackBar(context, 'Die E-Mail wurde erfolgreich geändert.');
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      MySnackBar.showMySnackBar(context, 'Die E-Mail konnte nicht geändert werden. Bitte versuchen Sie es später noch einmal.');
    }
  }

  Future<void> updatePassword(BuildContext context, String newPassword) async {
    User? user = _auth.currentUser;
    try {
      await user?.updatePassword(newPassword);
      MySnackBar.showMySnackBar(context, 'Das Passwort wurde erfolgreich geändert.');
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      MySnackBar.showMySnackBar(context, 'Das Passwort konnte nicht geändert werden. Bitte versuchen Sie es später noch einmal.');
    }
  }

  Future<void> deleteAccount(BuildContext context) async {
    User? user = _auth.currentUser;
    try {
      await user?.delete();
      MySnackBar.showMySnackBar(context, 'Ihr Account wurde erfolgreich gelöscht.');
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      MySnackBar.showMySnackBar(context, 'Es ist ein Fehler aufgetreten. Bitte versuchen Sie es später noch einmal.');
    }
  }
}
