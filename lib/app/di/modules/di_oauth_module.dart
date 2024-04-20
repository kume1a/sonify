import 'dart:io';

import 'package:domain_data/domain_data.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

@module
abstract class DiOauthModule {
  @lazySingleton
  GoogleSignIn get googleSignIn {
    return GoogleSignIn(
      clientId: Platform.isIOS ? AppEnvironment.googleAuthClientIdIos : null,
      serverClientId: Platform.isIOS ? AppEnvironment.googleAuthClientIdWeb : null,
    );
  }
}
