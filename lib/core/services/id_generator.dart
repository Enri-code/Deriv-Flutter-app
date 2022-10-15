import 'dart:math';

abstract class IDGenerator {
  static int random() => Random().nextInt(99999);
}
