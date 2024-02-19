import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import 'auth_with_google.dart';

@LazySingleton(as: AuthWithGoogle)
class AuthWithGoogleImpl implements AuthWithGoogle {
  AuthWithGoogleImpl(
    this._googleSignIn,
  );

  final GoogleSignIn _googleSignIn;

  @override
  Future<GoogleSignInAccount?> call() async {
    return _googleSignIn.signIn();
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
