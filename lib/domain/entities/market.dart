import 'package:deriv_test/domain/entities/market_symbol.dart';

class Market {
  final String name;
  final String id;
  List<MarketSymbol>? symbols;

  Market({
    required this.name,
    required this.id,
    this.symbols,
  });

  @override
  operator ==(dynamic other) => other is Market && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
