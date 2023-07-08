import 'dart:math';

class RandomIdGenerator {
  static const int randomIdLength = 20;

  static const String randomIdAlphabet =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

  static final Random random = Random.secure();

  static String autoId() {
    StringBuffer builder = StringBuffer();
    int maxRandom = randomIdAlphabet.length;
    for (var i = 0; i < randomIdLength; i++) {
      builder.write(randomIdAlphabet[random.nextInt(maxRandom)]);
    }
    return builder.toString();
  }
}
