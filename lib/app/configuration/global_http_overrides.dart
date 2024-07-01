import 'dart:io';

class GlobalHttpOverrides extends HttpOverrides {
  static configure() {
    HttpOverrides.global = GlobalHttpOverrides();
  }

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
