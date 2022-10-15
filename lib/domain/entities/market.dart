import 'package:deriv_test/domain/entities/market_symbol.dart';

class Market {
  final String name;
  final String marketId;
  List<MarketSymbol>? symbols;

  Market({
    required this.name,
    required this.marketId,
    this.symbols,
  });

  @override
  operator ==(dynamic other) => other is Market && other.marketId == marketId;

  @override
  int get hashCode => marketId.hashCode;
}
