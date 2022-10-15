import 'package:deriv_test/domain/entities/market_symbol.dart';

class Market {
  final String name;
  final String market;
  List<MarketSymbol>? symbols;

  Market({
    required this.name,
    required this.market,
    this.symbols,
  });

  @override
  operator ==(dynamic other) => other is Market && other.market == market;

  @override
  int get hashCode => market.hashCode;
}
