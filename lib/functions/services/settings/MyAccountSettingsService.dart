import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_app/exceptions/MyCustomException.dart';
import 'package:shopping_app/functions/services/firestore/MyFirestoreService.dart';
import 'package:shopping_app/functions/services/firestore/subclasses/UserService.dart';

import '../../../objects/users/MyUsers.dart';
import '../snackbars/MySnackBarService.dart';

class MyAccountSettingsService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Has the [MyCustomException] of [UserService.updateUserName]
  Future<void> updateNameFromCurrentUser(BuildContext context, String newPrename, String newSurname, String password) async {
    try {
      String userUuid = FirebaseAuth.instance.currentUser?.uid ?? '';
      await MyFirestoreService.userService.updateNameOfUser(userUuid, newPrename, newSurname, password);
      MySnackBarService.showMySnackBar(context, 'Name erfolgreich geändert', isError: false);
    } on MyCustomException catch (e) {

      switch (e.keyword) {

        case "empty-fields":
          MySnackBarService.showMySnackBar(context, 'Bitte füllen Sie alle Felder aus!');
          break;

        case "not-logged-in":
          MySnackBarService.showMySnackBar(context, 'Sie sind nicht eingeloggt!');
          break;

        case "wrong-password":
          MySnackBarService.showMySnackBar(context, 'Sie haben ein falsches Passwort eingegeben!');
          break;

        case "invalid-credential":
          MySnackBarService.showMySnackBar(context, 'Sie haben ein falsches Passwort eingegeben!');
          break;

        case "unknown-error":
          print(e.message);
          break;

      }

      return;
    }
  }

  Future<void> updateEmailFromCurrentUser(BuildContext context, String newEmail, String password) async {
    if (newEmail.trim().isEmpty || password.trim().isEmpty) {
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

      UserCredential userCredential = await user.reauthenticateWithCredential(credential);
      await userCredential.user!.verifyBeforeUpdateEmail(newEmail);
      MySnackBarService.showMySnackBar(context, 'Die Verifizierung-Email wurde an Ihre neue Email versendet!', isError: false);
    } on FirebaseAuthException catch (e) {

      switch (e.code) {

        case "invalid-credential":
          MySnackBarService.showMySnackBar(context, 'Sie haben ein falsches Passwort eingegeben!');
          break;

        case "wrong-password":
          MySnackBarService.showMySnackBar(context, 'Falsches Passwort.');
          break;

        case "too-many-requests'":
          MySnackBarService.showMySnackBar(context, 'Zu viele Anfragen. Versuchen Sie es später erneut.');
          break;

        case "network-request-failed":
          MySnackBarService.showMySnackBar(context, 'Netzwerkfehler. Überprüfen Sie Ihre Internetverbindung.');
          break;

        case "invalid-email":
          MySnackBarService.showMySnackBar(context, 'Ungültiges E-Mail-Format. Bitte überprüfen Sie Ihre E-Mail-Adresse.');
          break;

        default:
          MySnackBarService.showMySnackBar(context, 'Ein Fehler ist aufgetreten. Bitte kontaktieren Sie den Support!');
          print("Firebase Error Code: ${e.code}");
          break;

      }

      return;
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

      switch (e.code) {

        case "invalid-credential":
          MySnackBarService.showMySnackBar(context, 'Sie haben ein falsches Passwort eingegeben!');
          break;

        case "wrong-password":
          MySnackBarService.showMySnackBar(context, 'Falsches Passwort.');
          break;

        case "too-many-requests'":
          MySnackBarService.showMySnackBar(context, 'Zu viele Anfragen. Versuchen Sie es später erneut.');
          break;

        case "network-request-failed":
          MySnackBarService.showMySnackBar(context, 'Netzwerkfehler. Überprüfen Sie Ihre Internetverbindung.');
          break;

        case "invalid-email":
          MySnackBarService.showMySnackBar(context, 'Ungültiges E-Mail-Format. Bitte überprüfen Sie Ihre E-Mail-Adresse.');
          break;

        default:
          MySnackBarService.showMySnackBar(context, 'Ein Fehler ist aufgetreten. Bitte kontaktieren Sie den Support!');
          print("Firebase Error Code: ${e.code}");
          break;

      }

      return;
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

      UserCredential userCredential = await user.reauthenticateWithCredential(credential);
      await user.delete();

      MyUser userData = await MyFirestoreService.userService.getUserAsObject(user.uid);
      for (String groupUUID in userData.groupUUIDs) {

        if (await MyFirestoreService.groupService.isUserGroupOwner(groupUUID, user.uid)) {

          MyFirestoreService.groupService.removeGroup(groupUUID);
        } else {

          MyFirestoreService.groupService.removeUserUUIDFromGroup(groupUUID, user.uid);
        }
      }

      MyFirestoreService.userService.removeUser(user.uid);
      MySnackBarService.showMySnackBar(context, 'Ihr Account wurde erfolgreich gelöscht.', isError: false);
    } on FirebaseAuthException catch (e) {

      switch (e.code) {

        case "invalid-credential":
          MySnackBarService.showMySnackBar(context, 'Sie haben ein falsches Passwort eingegeben!');
          break;

        case "wrong-password":
          MySnackBarService.showMySnackBar(context, 'Falsches Passwort.');
          break;

        case "too-many-requests'":
          MySnackBarService.showMySnackBar(context, 'Zu viele Anfragen. Versuchen Sie es später erneut.');
          break;

        case "network-request-failed":
          MySnackBarService.showMySnackBar(context, 'Netzwerkfehler. Überprüfen Sie Ihre Internetverbindung.');
          break;

        case "invalid-email":
          MySnackBarService.showMySnackBar(context, 'Ungültiges E-Mail-Format. Bitte überprüfen Sie Ihre E-Mail-Adresse.');
          break;

        default:
          MySnackBarService.showMySnackBar(context, 'Ein Fehler ist aufgetreten. Bitte kontaktieren Sie den Support!');
          print("Firebase Error Code: ${e.code}");
          break;
      }

      return;
    } on MyCustomException catch(e) {

      switch(e.keyword) {
        case "snapshot-not-existent":
          print(e.message);
          break;
      }

      return;
    } catch(e) {

      print(e);
      return;
    }
  }
}
