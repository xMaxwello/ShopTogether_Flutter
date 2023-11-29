import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../snackbars/MySnackBarService.dart';

class MyAccountSettingsService {
  ///TODO: Also, eigentlich alle Funktionen wie du Sie hier beschreibst bzw. fast programmiert hast, sind MyFireStoreSerivce Funktionen.
  ///Die einzige Ausnahme ist, das in MyFirestoreService Funktionen kein BuildContext rein gehört.
  ///Um das jetzt einheitlich zu machen, guck erstens in MyFirestoreService, ob diese Funktion schon vorhanden sind 2) ergänze diese,
  ///allerdings überall wo ein Fehler oder wo du ein MySnackBar ausgeben würden packst du ein throw MyCustomException raus. Diese Exceptions
  ///bearbeitest du dann in diesen Funktionen hier mit der Ausgabe von den MySnackBars
  ///Falls du dir das nicht zu traust oder nicht weiß was ich mein, dann kann ich das machen. Allerdings müsste das sauber im
  ///Backend (MyFirestoreService) stehen
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> updateNameFromCurrentUser(BuildContext context, String newPrename, String newSurname, String password) async {
    if (newPrename.isEmpty || newSurname.isEmpty || password.isEmpty) {
      MySnackBarService.showMySnackBar(
          context, 'Bitte füllen Sie alle Felder aus.', isError: false);
    }

    User? user = _auth.currentUser;
    if (user == null) {
      MySnackBarService.showMySnackBar(
          context, 'Sie sind nicht angemeldet.', isError: true);
    }

    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
          {
            'prename': newPrename,
            'surname': newSurname,
          });
      MySnackBarService.showMySnackBar(context, 'Name erfolgreich geändert', isError: false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        MySnackBarService.showMySnackBar(context, 'Falsches Passwort.');
      } else if (e.code == 'too-many-requests') {
        MySnackBarService.showMySnackBar(context, 'Zu viele Anfragen. Versuchen Sie es später erneut.');
      } else if (e.code == 'network-request-failed') {
        MySnackBarService.showMySnackBar(context, 'Netzwerkfehler. Überprüfen Sie Ihre Internetverbindung.');
      } else {
        MySnackBarService.showMySnackBar(context, 'Ein Fehler ist aufgetreten. Bitte versuchen Sie es später noch einmal.');
        print("Firebase Error Code: ${e.code}");
      }
    }
  }

  Future<void> updateEmailFromCurrentUser(BuildContext context, String newEmail, String password) async {
    if (newEmail.isEmpty || password.isEmpty) {
      MySnackBarService.showMySnackBar(context, 'Bitte füllen Sie alle Felder aus.', isError: false);
    }

    User? user = _auth.currentUser;
    if (user == null) {
      MySnackBarService.showMySnackBar(context, 'Sie sind nicht angemeldet.', isError: true);
    }
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updateEmail(newEmail);
      MySnackBarService.showMySnackBar(context, 'Die E-Mail wurde erfolgreich geändert.', isError: false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        MySnackBarService.showMySnackBar(context, 'Falsches Passwort.');
    } else if (e.code == 'too-many-requests') {
        MySnackBarService.showMySnackBar(context, 'Zu viele Anfragen. Versuchen Sie es später erneut.');
    } else if (e.code == 'network-request-failed') {
        MySnackBarService.showMySnackBar(context, 'Netzwerkfehler. Überprüfen Sie Ihre Internetverbindung.');
    } else if (e.code == 'invalid-email') {
        MySnackBarService.showMySnackBar(context, 'Ungültiges E-Mail-Format. Bitte überprüfen Sie Ihre E-Mail-Adresse.');
      } else {
        MySnackBarService.showMySnackBar(context, 'Ein Fehler ist aufgetreten. Bitte kontaktieren Sie den Support!');
        print("Firebase Error Code: ${e.code}");
      }
    }
  }

  Future<void> updatePasswordFromCurrentUser(BuildContext context, String oldPassword, String newPassword, String repeatNewPassword) async {
    if (oldPassword.isEmpty || newPassword.isEmpty || repeatNewPassword.isEmpty) {
      MySnackBarService.showMySnackBar(context, 'Bitte füllen Sie alle Felder aus.');
    }

    if (newPassword != repeatNewPassword) {
      MySnackBarService.showMySnackBar(context, 'Die neuen Passwörter stimmen nicht überein.');
    }

    User? user = _auth.currentUser;
    if (user == null) {
      MySnackBarService.showMySnackBar(context, 'Sie sind nicht angemeldet.', isError: true);
    }

    AuthCredential credential = EmailAuthProvider.credential(
      email: user!.email!,
      password: oldPassword,
    );

    try {
      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPassword);
      MySnackBarService.showMySnackBar(context, 'Das Passwort wurde erfolgreich geändert.', isError: false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        MySnackBarService.showMySnackBar(context, 'Das alte Passwort ist nicht korrekt.');
      } else if (e.code == 'too-many-requests') {
        MySnackBarService.showMySnackBar(context, 'Zu viele Anfragen. Versuchen Sie es später erneut.');
      } else if (e.code == 'network-request-failed') {
        MySnackBarService.showMySnackBar(context, 'Netzwerkfehler. Überprüfen Sie Ihre Internetverbindung.');
      } else {
        MySnackBarService.showMySnackBar(context, 'Ein Fehler ist aufgetreten. Bitte versuchen Sie es später noch einmal.');
        print("Firebase Error Code: ${e.code}");
      }
    }
  }

  Future<void> deleteAccountFromCurrentUser(BuildContext context, String password) async {
    if (password.isEmpty) {
      MySnackBarService.showMySnackBar(context, 'Bitte füllen Sie alle Felder aus.', isError: false);
    }

    User? user = _auth.currentUser;
    if (user == null) {
      MySnackBarService.showMySnackBar(context, 'Sie sind nicht angemeldet.', isError: true);
    }

    AuthCredential credential = EmailAuthProvider.credential(
      email: user!.email!,
      password: password,
    );
    try {
      await user.reauthenticateWithCredential(credential);
      await user.delete();
      MySnackBarService.showMySnackBar(context, 'Ihr Account wurde erfolgreich gelöscht.', isError: false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        MySnackBarService.showMySnackBar(context, 'Das alte Passwort ist nicht korrekt.');
      } else if (e.code == 'network-request-failed') {
        MySnackBarService.showMySnackBar(context, 'Netzwerkfehler. Überprüfen Sie Ihre Internetverbindung.');
      } else {
        MySnackBarService.showMySnackBar(context, 'Es ist ein Fehler aufgetreten. Bitte versuchen Sie es später noch einmal.');
        print("Firebase Error Code: ${e.code}");
      }
    }
  }

}
