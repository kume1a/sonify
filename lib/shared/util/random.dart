import 'dart:math';

final _r = Random();

String randomString(int len) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  return List.generate(len, (index) => chars[_r.nextInt(chars.length - 1)]).join();
}

int randomInt(int min, int max) {
  return min + _r.nextInt(max - min);
}

double randomDouble(double min, double max) {
  return min + _r.nextDouble() * (max - min);
}

bool randomBool() {
  return _r.nextBool();
}
