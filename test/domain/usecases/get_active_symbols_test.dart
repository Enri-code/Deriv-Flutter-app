import 'package:dartz/dartz.dart';
import 'package:deriv_test/domain/entities/market.dart';
import 'package:deriv_test/domain/repos/price_tracker_repo.dart';
import 'package:deriv_test/domain/usecases/get_active_symbols.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_active_symbols_test.mocks.dart';

@GenerateMocks([IPriceTrackerRepo])
void main() {
  late GetActiveSymbols usecase;
  late MockIPriceTrackerRepo mockPriceTrackerRepo;

  setUp(() {
    mockPriceTrackerRepo = MockIPriceTrackerRepo();
    usecase = GetActiveSymbols(mockPriceTrackerRepo);
  });

  const response = <Market>[];

  test(
    'should get active symbols from the repo',
    () async {
      //When [getSymbols] is called, it should return the [Right] of the
      //Either argument.
      when(mockPriceTrackerRepo.getSymbols()).thenAnswer(
        (_) async => const Right(response),
      );

      ///Call the usecase function
      final result = await usecase();

      // Usecase should return what was returned from the repo
      expect(result, const Right(response));

      // Verify that the function was called on the repo
      verify(mockPriceTrackerRepo.getSymbols()).called(1);

      // Verify no other method was called on the repo.
      verifyNoMoreInteractions(mockPriceTrackerRepo);
    },
  );
}
