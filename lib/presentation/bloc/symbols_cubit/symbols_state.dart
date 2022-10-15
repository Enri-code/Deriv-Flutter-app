part of 'symbols_cubit.dart';

abstract class SymbolsState extends Equatable {
  const SymbolsState({
    this.status = OperationStatus.initial,
    this.markets,
    this.errorMessage,
  });

  final String? errorMessage;
  final OperationStatus status;
  final Stream<List<Market>>? markets;

  SymbolsState copyWith({OperationStatus? status, String? errorMessage});

  @override
  List<Object?> get props => [status, markets, errorMessage];
}

///The state when the active symbols are queried
class ActiveSymbolsState extends SymbolsState {
  const ActiveSymbolsState({super.status, super.markets, super.errorMessage});

  @override
  ActiveSymbolsState copyWith({
    OperationStatus? status,
    String? errorMessage,
    Stream<List<Market>>? markets,
  }) {
    return ActiveSymbolsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      markets: markets ?? this.markets,
    );
  }
}

///The state when the price tick is queried
class SymbolTicksState extends SymbolsState {
  const SymbolTicksState({
    super.status,
    this.priceTicks,
    super.markets,
    super.errorMessage,
  });

  final Stream<num>? priceTicks;

  @override
  SymbolTicksState copyWith({
    OperationStatus? status,
    String? errorMessage,
    Stream<num>? priceTicks,
    Stream<List<Market>>? markets,
  }) {
    return SymbolTicksState(
      status: status ?? super.status,
      priceTicks: priceTicks ?? this.priceTicks,
      errorMessage: errorMessage ?? this.errorMessage,
      markets: markets ?? super.markets,
    );
  }

  @override
  List<Object?> get props => [priceTicks, ...super.props];
}
