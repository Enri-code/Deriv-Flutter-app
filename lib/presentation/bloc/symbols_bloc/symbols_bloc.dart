import 'dart:async';

import 'package:deriv_test/core/utils/operation_status.dart';
import 'package:deriv_test/domain/entities/market.dart';
import 'package:deriv_test/core/utils/app_error.dart';
import 'package:deriv_test/domain/repos/price_tracker_repo.dart';
import 'package:deriv_test/domain/usecases/get_active_symbols.dart';
import 'package:deriv_test/domain/usecases/get_price_ticks.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'symbols_state.dart';
part 'symbols_event.dart';

class SymbolsBloc extends Bloc<SymbolsEvent, SymbolsState> {
  SymbolsBloc(this._repo) : super(const SymbolsState()) {
    on<GetSymbolsEvent>(_getSymbols);
    on<GetSymbolTicksEvent>(_getTicks);
  }

  final IPriceTrackerRepo _repo;
  // late SymbolsState _lastState;

  ///Emits the error state
  _onError(AppError error, Emitter<SymbolsState> emit) {
    emit(state.copyWith(
      status: OperationStatus.error,
      errorMessage: error.errMessage,
    ));
  }

  ///Fetched the active symbols and arranges it based on the market and symbol
  Future _getSymbols(GetSymbolsEvent event, Emitter<SymbolsState> emit) async {
    emit(const SymbolsState(status: OperationStatus.loading));

    final result = await GetActiveSymbols(_repo).call();

    result.fold(
      //Callback when error is returned, [Left] side of Either
      (l) => _onError(l, emit),
      (r) {
        ///Store the last symbol name, to be used to query the forget tick api
        emit(state.copyWith(status: OperationStatus.success, markets: r));
      },
    );
  }

  Future _getTicks(
    GetSymbolTicksEvent event,
    Emitter<SymbolsState> emit,
  ) async {
    emit(SymbolTicksState(
      status: OperationStatus.loading,
      markets: state.markets,
      priceTicks: null,
    ));

    final result = GetPriceTicks(_repo, symbol: event.symbolName).call();

    emit((state as SymbolTicksState).copyWith(
      status: OperationStatus.success,
      markets: state.markets,
      priceTicks: result.ticksStream,
    ));
  }
}
