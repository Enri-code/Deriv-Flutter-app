import 'dart:async';

import 'package:deriv_test/core/utils/operation_status.dart';
import 'package:deriv_test/domain/usecases/forget.dart';
import 'package:deriv_test/domain/entities/market.dart';
import 'package:deriv_test/core/utils/app_error.dart';
import 'package:deriv_test/domain/repos/price_tracker_repo.dart';
import 'package:deriv_test/domain/usecases/get_active_symbols.dart';
import 'package:deriv_test/domain/usecases/get_price_ticks.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'symbols_state.dart';

class SymbolsCubit extends Cubit<SymbolsState> {
  SymbolsCubit(this._repo) : super(const ActiveSymbolsState());

  final IPriceTrackerRepo _repo;

  int? _lastRequestId;
  late SymbolsState _lastState;

  ///Emits the error state
  _onError(AppError error) {
    emit(_lastState.copyWith(
      status: OperationStatus.error,
      errorMessage: error.errMessage,
    ));
  }

  ///Fetched the active symbols and arranges it based on the market and symbol
  Future getSymbols() async {
    emit(
      _lastState = const ActiveSymbolsState(status: OperationStatus.loading),
    );
    final result = await GetActiveSymbols(_repo).call();
    result.fold(
      //Callback when error is returned, [Left] side of Either
      _onError,
      (r) {
        ///Store the last symbol name, to be used to query the forget tick api
        emit((_lastState as ActiveSymbolsState).copyWith(
          status: OperationStatus.success,
          markets: r,
        ));
      },
    );
  }

  Future getTicks(String symbolName) async {
    ///Forgets the previous price tick that was connected
    if (_lastRequestId != null) {
      Forget(_repo, requestId: _lastRequestId!).call();
      //Reset request id so it doesn't get queried two times
      _lastRequestId = null;
    }
    emit(_lastState = SymbolTicksState(
      status: OperationStatus.loading,
      markets: state.markets,
      priceTicks: null,
    ));

    final result = await GetPriceTicks(_repo, symbol: symbolName).call();
    result.fold(
      _onError,
      (r) {
        ///Store the last symbol name, to be used to query the forget tick api
        _lastRequestId = r.requestId;
        emit((_lastState as SymbolTicksState).copyWith(
          status: OperationStatus.success,
          markets: state.markets,
          priceTicks: r.data,
        ));
      },
    );
  }
}
