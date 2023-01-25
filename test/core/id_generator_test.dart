import 'package:deriv_test/core/services/id_generator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'should return random integer from randomInt generator',
    () async {
      final generated1 = IDGenerator.randomInt();
      final generated2 = IDGenerator.randomInt();

      //Calling generated values multiple times returns different values
      expect(generated1, isNot(generated2));
    },
  );
}
