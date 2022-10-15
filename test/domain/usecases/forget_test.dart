import 'package:dartz/dartz.dart';
import 'package:deriv_test/domain/usecases/forget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'get_active_symbols_test.mocks.dart';

void main() {
  late Forget usecase;
  late MockIPriceTrackerRepo mockPriceTrackerRepo;

  setUp(() {
    mockPriceTrackerRepo = MockIPriceTrackerRepo();
    usecase = Forget(mockPriceTrackerRepo, requestId: 3);
  });

  test(
    'should forget stream with requestId',
    () async {
      //When [forget] is called, it should return the [Right] of the
      //Either argument.
      when(mockPriceTrackerRepo.forget(3)).thenAnswer(
        (_) async => const Right(null),
      );

      ///Call the usecase function
      final result = await usecase();

      // Usecase should return what was returned from the repo
      expect(result, const Right(null));

      // Verify that the function was called on the repo
      verify(mockPriceTrackerRepo.forget(3)).called(1);

      // Verify no other method was called on the repo.
      verifyNoMoreInteractions(mockPriceTrackerRepo);
    },
  );
}
