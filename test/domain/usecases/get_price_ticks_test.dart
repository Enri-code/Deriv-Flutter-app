import 'package:dartz/dartz.dart';
import 'package:deriv_test/core/utils/socket_response.dart';
import 'package:deriv_test/domain/usecases/get_price_ticks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'get_active_symbols_test.mocks.dart';

void main() {
  late GetPriceTicks usecase;
  late MockIPriceTrackerRepo mockPriceTrackerRepo;

  setUp(() {
    mockPriceTrackerRepo = MockIPriceTrackerRepo();
    usecase = GetPriceTicks(mockPriceTrackerRepo, symbol: 'symbol');
  });

  const response = ResponseWithSubId(
    data: Stream<double>.empty(),
    requestId: 4,
  );

  test(
    'should get price ticks from the repo',
    () async {
      //When [getTicks] is called, it should return the [Right] of the
      //Either argument.
      when(mockPriceTrackerRepo.getTicks('symbol')).thenAnswer((_) async {
        return const Right(response);
      });

      ///Call the usecase function
      final result = await usecase();

      // Usecase should return what was returned from the repo
      expect(result, const Right(response));

      // Verify that the function was called on the repo
      verify(mockPriceTrackerRepo.getTicks('symbol')).called(1);

      // Verify no other method was called on the repo.
      verifyNoMoreInteractions(mockPriceTrackerRepo);
    },
  );
}
