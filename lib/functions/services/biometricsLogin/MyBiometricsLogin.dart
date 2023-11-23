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
}