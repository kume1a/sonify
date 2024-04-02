import 'dart:math';

String randomString(int len) {
  var r = Random();
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  return List.generate(len, (index) => chars[r.nextInt(chars.length - 1)]).join();
}
