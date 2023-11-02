import 'package:firebase_auth/firebase_auth.dart';

class MyFirebaseAuth {

  static Future<bool> checkIfEmailInUse(String emailAdress) async {
    try {
      final list = await FirebaseAuth.instance.fetchSignInMethodsForEmail(emailAdress);

      if (list.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return true;
    }
  }

}