import 'package:dartz/dartz.dart';
import 'package:deriv_test/core/utils/app_error.dart';
import 'package:deriv_test/data/repos/price_tracker_repo.dart';
import 'package:deriv_test/domain/entities/market.dart';
import 'package:deriv_test/domain/repos/price_tracker_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import './price_tracker_repo_test.mocks.dart';

@GenerateMocks([IPriceTrackerService])
void main() {
  late PriceTrackerRepoImpl repo;
  late IPriceTrackerService service;

  setUp(() {
    service = MockIPriceTrackerService();
    repo = PriceTrackerRepoImpl(service);
  });

  group(
    'Price Tracker Repo Implementation test',
    () {
      test(
        'should get active symbols from the service',
        () async {
          //When [getSymbols] is called, it should return value
          when(service.getSymbols()).thenAnswer(
            (_) async => const <Map<String, dynamic>>[],
          );

          final result = await repo.getSymbols();

          expect(result, isA<Right>());
          expect((result as Right<AppError, List<Market>>).value, isEmpty);
          // Verify that the function was called on the repo
          verify(service.getSymbols()).called(1);

          // Verify no other method was called on the repo.
          verifyNoMoreInteractions(service);
        },
      );
    },
  );
}
