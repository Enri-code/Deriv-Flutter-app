part of 'symbols_bloc.dart';

///The state when the active symbols are queried
class SymbolsState extends Equatable {
  const SymbolsState({
    this.status = OperationStatus.initial,
    this.markets,
    this.errorMessage,
  });

  final String? errorMessage;
  final OperationStatus status;
  final List<Market>? markets;

  SymbolsState copyWith({
    OperationStatus? status,
    String? errorMessage,
    List<Market>? markets,
  }) {
    return SymbolsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      markets: markets ?? this.markets,
    );
  }

  @override
  List<Object?> get props => [status, markets, errorMessage];
}

///The state when the price tick is queried
class SymbolTicksState extends SymbolsState {
  const SymbolTicksState({
    super.status,
    this.priceTicks,
    super.markets,
    super.errorMessage,
  });

  final Stream<String>? priceTicks;

  @override
  SymbolTicksState copyWith({
    OperationStatus? status,
    String? errorMessage,
    Stream<String>? priceTicks,
    List<Market>? markets,
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
