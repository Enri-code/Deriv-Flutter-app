import 'dart:math';

abstract class IDGenerator {
  static int randomInt() => Random().nextInt(99999);
}
