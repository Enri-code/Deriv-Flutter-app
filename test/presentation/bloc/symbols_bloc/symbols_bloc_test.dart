import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:deriv_test/core/utils/app_error.dart';
import 'package:deriv_test/core/utils/operation_status.dart';
import 'package:deriv_test/core/utils/socket_response.dart';
import 'package:deriv_test/domain/repos/price_tracker_repo.dart';
import 'package:deriv_test/presentation/bloc/symbols_bloc/symbols_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../domain/usecases/get_active_symbols_test.mocks.dart';

void main() {
  late IPriceTrackerRepo repo;

  setUp(() {
    repo = MockIPriceTrackerRepo();
  });

  group(
    'Symbols bloc test',
    () {
      blocTest<SymbolsBloc, SymbolsState>(
        'should return a stream from getSymbols and change state\'s status to success',
        setUp: () async {
          when(repo.getSymbols()).thenAnswer((_) async => const Right([]));
        },
        build: () => SymbolsBloc(repo),
        act: (bloc) => bloc.add(GetSymbolsEvent()),
        expect: () => const [
          SymbolsState(status: OperationStatus.loading),
          SymbolsState(status: OperationStatus.success, markets: [])
        ],
        verify: (bloc) {
          verify(repo.getSymbols()).called(1);
          verifyNoMoreInteractions(repo);
        },
      );

      blocTest<SymbolsBloc, SymbolsState>(
        'should return error getSymbols and change state\'s status to success',
        setUp: () async {
          when(repo.getSymbols()).thenAnswer((_) async {
            return const Left(AppError());
          });
        },
        build: () => SymbolsBloc(repo),
        act: (bloc) => bloc.add(GetSymbolsEvent()),
        expect: () => const [
          SymbolsState(status: OperationStatus.loading),
          SymbolsState(status: OperationStatus.error, markets: null)
        ],
        verify: (bloc) {
          verify(repo.getSymbols()).called(1);
          verifyNoMoreInteractions(repo);
        },
      );

      blocTest<SymbolsBloc, SymbolsState>(
        'should return a stream from getTicks and change state\'s status to success',
        setUp: () async {
          when(repo.getTicks('symbol')).thenAnswer((_) async {
            const response = TicksResponse(
              ticksStream: Stream<num>.empty(),
              subscriptionId: 0,
            );
            return const Right(response);
          });
        },
        build: () => SymbolsBloc(repo),
        act: (bloc) => bloc.add(const GetSymbolTicksEvent('symbol')),
        expect: () {
          return const [
            SymbolTicksState(
              status: OperationStatus.loading,
              markets: null,
              priceTicks: null,
            ),
            SymbolTicksState(
              status: OperationStatus.success,
              markets: null,
              priceTicks: Stream<num>.empty(),
            )
          ];
        },
        verify: (bloc) {
          verify(repo.getTicks('symbol')).called(1);
          verifyNoMoreInteractions(repo);
        },
      );

      blocTest<SymbolsBloc, SymbolsState>(
        'should return error from getTicks and change state\'s status to success',
        setUp: () async {
          when(repo.getTicks('symbol')).thenAnswer((_) async {
            return const Left(AppError());
          });
        },
        build: () => SymbolsBloc(repo),
        act: (bloc) => bloc.add(const GetSymbolTicksEvent('symbol')),
        expect: () {
          return const [
            SymbolTicksState(
              status: OperationStatus.loading,
              markets: null,
              priceTicks: null,
            ),
            SymbolTicksState(
              status: OperationStatus.error,
              markets: null,
              priceTicks: null,
            )
          ];
        },
        verify: (bloc) {
          verify(repo.getTicks('symbol')).called(1);
          verifyNoMoreInteractions(repo);
        },
      );
    },
  );
}
