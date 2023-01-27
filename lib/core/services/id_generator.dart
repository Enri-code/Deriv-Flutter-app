import 'package:random_string/random_string.dart';

abstract class IDGenerator {
  IDGenerator._();
  static String randomString() => randomNumeric(120);
}
