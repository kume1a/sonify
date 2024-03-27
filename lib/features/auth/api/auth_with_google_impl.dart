import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import 'auth_with_google.dart';

@LazySingleton(as: AuthWithGoogle)
class AuthWithGoogleImpl implements AuthWithGoogle {
  AuthWithGoogleImpl(
    this._googleSignIn,
  );

  final GoogleSignIn _googleSignIn;

  @override
  Future<GoogleSignInAccount?> call() async {
    try {
      return _googleSignIn.signIn();
    } catch (e) {
      Logger.root.severe('Error signing in with Google: $e');
    }

    return null;
  }

  @override
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      Logger.root.severe('Error signing out with Google: $e');
    }
  }
}
