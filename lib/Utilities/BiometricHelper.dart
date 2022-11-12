import 'package:local_auth/local_auth.dart';
// ···

class BiometricHelper {
  final LocalAuthentication _auth = LocalAuthentication();

  // ···

  Future<bool> canAuthenticateWithBiometrics() async {
    final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
    if (canAuthenticateWithBiometrics && canAuthenticate) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> hasEnrolledBiometrics() async {
    final List<BiometricType> availableBiometrics =
        await _auth.getAvailableBiometrics();
    if (availableBiometrics.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> authenticate() async {
    final bool didAuthenticate = await _auth.authenticate(
        localizedReason: "Please Authenticate to proceed",
        options: const AuthenticationOptions(biometricOnly: true));
    return didAuthenticate;
  }
}

  // ···
