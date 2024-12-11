import 'dart:math';

class GenerateRandom {
  static String generateRandomString(int length) {
    const availableChars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final random = Random();
    final randomString = StringBuffer();

    for (int i = 0; i < 5; i++) {
      final index = random.nextInt(availableChars.length);
      randomString.write(availableChars[index]);
    }

    return randomString.toString();
  }

  static String generateRandomNum(int length) {
    const availableChars = '1234567890';
    final random = Random();
    final randomString = StringBuffer();

    for (int i = 0; i < 5; i++) {
      final index = random.nextInt(availableChars.length);
      randomString.write(availableChars[index]);
    }

    return randomString.toString();
  }
}
