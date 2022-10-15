import 'package:dartz/dartz.dart';
import 'package:deriv_test/core/utils/operation_status.dart';
import 'package:deriv_test/core/utils/socket_response.dart';
import 'package:deriv_test/domain/entities/market.dart';
import 'package:deriv_test/domain/repos/price_tracker_repo.dart';
import 'package:deriv_test/presentation/bloc/symbols_cubit/symbols_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../domain/usecases/get_active_symbols_test.mocks.dart';

void main() {
  late SymbolsCubit bloc;
  late IPriceTrackerRepo repo;

  setUp(() {
    repo = MockIPriceTrackerRepo();
    bloc = SymbolsCubit(repo);
  });

  group(
    'Symbols bloc test',
    () {
      test(
        'initial values are correct',
        () {
          expect(bloc.state, isA<ActiveSymbolsState>());
          expect(bloc.state.markets, null);
          expect(bloc.state.status, OperationStatus.initial);
        },
      );

      testGetSymbols() async {
        when(repo.getSymbols()).thenAnswer(
          (_) async {
            const response = Stream<List<Market>>.empty();
            return const Right(response);
          },
        );
        await bloc.getSymbols();
        verify(repo.getSymbols()).called(1);
        expect(bloc.state, isA<ActiveSymbolsState>());
        expect(bloc.state.status, OperationStatus.success);
        expect(
          bloc.state.markets,
          allOf([isNotNull, isA<Stream<List<Market>>>()]),
        );
      }

      test(
        'should return a stream from getSymbols and change state\'s status to success',
        testGetSymbols,
      );

      test(
        'should return a stream from getTicks and change state\'s status to success',
        () async {
          when(repo.getTicks('symbol')).thenAnswer((_) async {
            const response = ResponseWithSubId(
              data: Stream<num>.empty(),
              requestId: 0,
            );
            return const Right(response);
          });
          await bloc.getTicks('symbol');
          verify(repo.getTicks('symbol')).called(1);
          expect(bloc.state, isA<SymbolTicksState>());
          final ticksState = bloc.state as SymbolTicksState;
          expect(ticksState.status, OperationStatus.success);
          expect(
            ticksState.priceTicks,
            allOf([isNotNull, isA<Stream<num>>()]),
          );
        },
      );
    },
  );
}
