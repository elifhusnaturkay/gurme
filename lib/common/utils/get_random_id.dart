import 'dart:math';

class AutoIdGenerator {
  static const int autoIdLength = 20;

  static const String autoIdAlphabet =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

  static final Random random = Random.secure();

  static String autoId() {
    StringBuffer builder = StringBuffer();
    int maxRandom = autoIdAlphabet.length;
    for (var i = 0; i < autoIdLength; i++) {
      builder.write(autoIdAlphabet[random.nextInt(maxRandom)]);
    }
    return builder.toString();
  }
}
