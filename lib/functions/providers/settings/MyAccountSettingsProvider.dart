import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/snackbars/MySnackBarService.dart';

class MyAccountSettingsProvider with ChangeNotifier { ///TODO: Rename die Klasse. Was du hier gecodest hast ist ein Service kein Provider (Bitte pack den Service dann unter functions/services/(neuer Ordner))
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> updateEmail(BuildContext context, String newEmail, String password) async { ///TODO: Ich weiß ist blöd, aber versuche den Funktionsnamen deutlicher zu formulieren: updateEmail (zu undeutlich) => updateEmailFromCurrentUser (deutlicher), weil diese Funktion nur die Email vom aktuellen User ändern kann und nicht von allen
    if (newEmail.isEmpty || password.isEmpty) {
      MySnackBarService.showMySnackBar(context, 'Bitte füllen Sie alle Felder aus.', isError: false);
      return; ///TODO: return ist hier fehlerhaft: ist eine void Funktion
    }

    User? user = _auth.currentUser; ///TODO: Ich weiß nicht ob das hier wirklich der Fall ist, könnte aber vielleicht Fehler beheben, indem du guckst ob der User überhaupt eingeloggt ist if (user != null)
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updateEmail(newEmail);
      MySnackBarService.showMySnackBar(context, 'Die E-Mail wurde erfolgreich geändert.', isError: false);
    } on FirebaseAuthException catch (e) {
      ///TODO: Plus gib niemals für den User Fehler: ${e.message} aus, der Versteht das nicht. Sehr wahrscheinlich wolltest du das noch ändern, nur als erinnerung
      MySnackBarService.showMySnackBar(context, 'Fehler: ${e.message}'); ///TODO: Versuche hier die FirebaseExceptions genau raus zu filtern, kein internet, account nicht da, ...
    }
  }

  Future<void> updatePassword(BuildContext context, String oldPassword, String newPassword, String repeatNewPassword) async { ///TODO: Hier das selbe: updatePassword (zu undeutlich) => updatePasswordFromCurrentUser (deutlicher)
    if (oldPassword.isEmpty || newPassword.isEmpty || repeatNewPassword.isEmpty) {
      MySnackBarService.showMySnackBar(context, 'Bitte füllen Sie alle Felder aus.');
      return; ///TODO: return wieder fehlerhaft
    }

    if (newPassword != repeatNewPassword) {
      MySnackBarService.showMySnackBar(context, 'Die neuen Passwörter stimmen nicht überein.');
      return; ///TODO: return wieder fehlerhaft
    }

    User? user = _auth.currentUser; ///TODO: hier wieder abfrage ob User eingeloggt ist noch if (user != null), falls es was hilft. Sollte aber eig. besser sein. Müsstest du nochmal gucken

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
      } else {
        MySnackBarService.showMySnackBar(context, 'Ein Fehler ist aufgetreten. Bitte versuchen Sie es später noch einmal.'); ///TODO: Versuche hier die FirebaseExceptions genau raus zu filtern, kein internet, account nicht da, ...
      }
    }
  }

  Future<void> deleteAccount(BuildContext context) async { ///TODO: Hier auch: deleteAccount => deleteAccountFromCurrentUser / deleteCurrentUserAccount (irgendwie sowas, muss aber deutlicher werden, dass hier nur der aktueller User gemeint ist)
    User? user = _auth.currentUser;
    try {
      await user?.delete();
      MySnackBarService.showMySnackBar(context, 'Ihr Account wurde erfolgreich gelöscht.', isError: false);
      notifyListeners(); ///TODO: Überprüfe ob du das hier wirklich brauchst! notifyListeners wird eig. nur in einem Provider aufgerufen, außerdem dann nur für die Variablen in dem Provider. Muss aber nicht falsch sein. Nur unüblich
    } on FirebaseAuthException catch (e) {
      MySnackBarService.showMySnackBar(context, 'Es ist ein Fehler aufgetreten. Bitte versuchen Sie es später noch einmal.'); ///TODO: Versuche hier die FirebaseExceptions genau raus zu filtern, kein internet, account nicht da, ...
    }
  }
}
