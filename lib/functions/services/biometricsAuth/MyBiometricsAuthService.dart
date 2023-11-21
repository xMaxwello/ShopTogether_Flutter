import 'package:local_auth/local_auth.dart';
import 'package:shopping_app/exceptions/MyCustomException.dart';

class MyBiometricsAuthService {

  ///the function authenticate with faceId, fingerprint the user
  ///
  /// [MyCustomException] key words:
  /// - 'weak': the biometric types are to weak
  Future<bool> authenticate() async {

    LocalAuthentication auth = LocalAuthentication();
    bool isBiometricsAvailable = await auth.canCheckBiometrics;
    bool isAuthenticateAvailable = isBiometricsAvailable || await auth.isDeviceSupported();

    if (isAuthenticateAvailable) {

      List<BiometricType> biometricsOptions = await auth.getAvailableBiometrics();

      if (biometricsOptions.contains(BiometricType.weak)) {

        throw MyCustomException("the biometric types are to weak", "weak");
      }
    } else {

      throw Exception("the authentification is not available!");
    }

    return true;
  }
}