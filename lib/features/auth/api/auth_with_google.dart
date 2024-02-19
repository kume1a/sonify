import 'package:google_sign_in/google_sign_in.dart';

abstract interface class AuthWithGoogle {
  Future<GoogleSignInAccount?> call();

  Future<void> signOut();
}
