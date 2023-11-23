import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_app/exceptions/MyCustomException.dart';
import 'package:shopping_app/functions/services/biometricsAuth/MyBiometricsAuthService.dart';
import 'package:shopping_app/functions/services/storage/MySecureStorageService.dart';
import 'package:shopping_app/objects/users/MyDefaultUserStructure.dart';

class MyBiometricsLogin {

  static Future<MyDefaultUserStructure> getUserDataFromBiometrics() async {

    late bool isAuthenticate;
    MyBiometricsAuthService myBiometricsAuthService = MyBiometricsAuthService();
    try {

      isAuthenticate = await myBiometricsAuthService.authenticate();
    } catch(e) {

      isAuthenticate = false;

      if (e is MyCustomException) {

        switch(e.keyword) {

          case "authentication-failed":

            break;
          case "weak":

            break;
          case "not-available":

            break;
        }
      }
    }

    MySecureStorageService mySecureStorageService = MySecureStorageService();
    if (isAuthenticate) {

      return mySecureStorageService.getUserFromStorage();
    }

    return MyDefaultUserStructure(
        email: "",
        password: ""
    );
  }

  /// This function logged in the user with biometrics automatically
  ///
  /// [MyCustomException] Keys:
  /// - email-password-null: email or password are null!
  /// - email-password-empty: email or password are empty!
  static void loginWithBiometrics() async {
    MyDefaultUserStructure myUser = await getUserDataFromBiometrics();

    if (myUser.email == null || myUser.password == null) {

      throw MyCustomException("email or password are null!", "email-password-null");
    }

    if (myUser.email == "" || myUser.password == "") {

      throw MyCustomException("email or password are empty!", "email-password-empty");
    }

    try {

      await FirebaseAuth.instance.signInWithEmailAndPassword(email: myUser.email!, password: myUser.password!);
    } catch (e) {

      if (e is FirebaseException) {

        throw MyCustomException(e.message == null ? "" : e.message!, e.code);
      }
    }
  }
}