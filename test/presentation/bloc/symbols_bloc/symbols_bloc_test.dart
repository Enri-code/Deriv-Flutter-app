import 'package:dartz/dartz.dart';
import 'package:deriv_test/core/utils/operation_status.dart';
import 'package:deriv_test/core/utils/socket_response.dart';
import 'package:deriv_test/domain/entities/market.dart';
import 'package:deriv_test/domain/repos/price_tracker_repo.dart';
import 'package:deriv_test/presentation/bloc/symbols_bloc/symbols_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../domain/usecases/get_active_symbols_test.mocks.dart';

void main() {
  late SymbolsBloc bloc;
  late IPriceTrackerRepo repo;

  setUp(() {
    repo = MockIPriceTrackerRepo();
    bloc = SymbolsBloc(repo);
  });

  group(
    'Symbols bloc test',
    () {
      test(
        'initial values are correct',
        () {
          expect(bloc.state, isA<SymbolsState>());
          expect(bloc.state.markets, null);
          expect(bloc.state.status, OperationStatus.initial);
        },
      );

      test(
        'should return a stream from getSymbols and change state\'s status to success',
        () async {
          when(repo.getSymbols()).thenAnswer(
            (_) async {
              const response = Stream<List<Market>>.empty();
              return const Right(response);
            },
          );
          await bloc.getSymbols();
          verify(repo.getSymbols()).called(1);
          expect(bloc.state, isA<SymbolsState>());
          expect(bloc.state.status, OperationStatus.success);
          expect(
            bloc.state.markets,
            allOf([isNotNull, isA<Stream<List<Market>>>()]),
          );
        },
      );

      test(
        'should return a stream from getTicks and change state\'s status to success',
        () async {
          when(repo.getTicks('symbol')).thenAnswer((_) async {
            const response = TicksResponse(
              ticksStream: Stream<num>.empty(),
              subscriptionId: 0,
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
