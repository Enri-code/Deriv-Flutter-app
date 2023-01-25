import 'dart:math';

abstract class IDGenerator {
  IDGenerator._();
  static int randomInt() => Random().nextInt(99999);
}
