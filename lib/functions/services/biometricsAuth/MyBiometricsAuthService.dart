import 'package:local_auth/local_auth.dart';
import 'package:shopping_app/exceptions/MyCustomException.dart';

class MyBiometricsAuthService {

  ///the function authenticate with faceId, fingerprint the user
  ///
  /// [MyCustomException] key words:
  /// - 'authentication-failed': the authentiation failed
  /// - 'weak': the authentication types are to weak
  /// - 'not-available': the authentification is not available
  Future<bool> authenticate() async {

    bool isAuthenticate = false;

    LocalAuthentication auth = LocalAuthentication();
    bool isBiometricsAvailable = await auth.canCheckBiometrics;
    bool isAuthenticateAvailable = isBiometricsAvailable || await auth.isDeviceSupported();

    if (isAuthenticateAvailable) {

      List<BiometricType> biometricsOptions = await auth.getAvailableBiometrics();

      if (biometricsOptions.contains(BiometricType.strong)) {

        try {

          isAuthenticate = await auth.authenticate(
              localizedReason: 'Please authenticate to show account balance',
              options: const AuthenticationOptions(biometricOnly: true));
        } catch (e) {

          throw MyCustomException("the authentiation failed: $e", "authentication-failed");
        }
      } else {

        throw MyCustomException("the authentication types are to weak", "weak");
      }
    } else {

      throw MyCustomException("the authentification is not available!", "not-available");
    }

    return isAuthenticate;
  }

  
}