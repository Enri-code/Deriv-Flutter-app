import 'package:deriv_test/domain/entities/market_symbol.dart';

class MarketSymbolModel extends MarketSymbol {
  MarketSymbolModel._({
    required super.displayName,
    required super.symbolId,
    required super.marketId,
  });

  factory MarketSymbolModel.fromMap(Map<String, dynamic> map) {
    return MarketSymbolModel._(
      displayName: map['display_name'],
      symbolId: map['symbol'],
      marketId: map['market'],
    );
  }
}
