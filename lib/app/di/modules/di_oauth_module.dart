import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import '../../configuration/app_environment.dart';

@module
abstract class DiOauthModule {
  @lazySingleton
  GoogleSignIn get googleSignIn {
    return GoogleSignIn(
      clientId: Platform.isIOS ? AppEnvironment.googleAuthClientIdIos : null,
    );
  }
}
