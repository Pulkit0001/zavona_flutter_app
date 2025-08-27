import 'package:google_sign_in/google_sign_in.dart';

abstract class SsoService {
  static Future<void> signInWithGoogle() async {
    try {
      GoogleSignIn googleSigner = GoogleSignIn.instance;
      await googleSigner.initialize();
      await googleSigner.signOut();
      var googleAccount = await googleSigner.authenticate(
        scopeHint: ['email', 'profile'],
      );
      googleAccount.displayName;
      googleAccount.email;
      googleAccount.id;
      googleAccount.photoUrl;
      googleAccount.authentication.idToken;
    } catch (e) {
      // Handle error
    }
  }

  static Future<void> signInWithFacebook() async {}
  static Future<void> signOut() async {}
}
