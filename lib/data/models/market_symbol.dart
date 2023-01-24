import 'package:deriv_test/domain/entities/market_symbol.dart';

class MarketSymbolModel extends MarketSymbol {
  MarketSymbolModel._({
    required super.displayName,
    required super.id,
    required super.marketId,
  });

  factory MarketSymbolModel.fromMap(Map<String, dynamic> map) {
    return MarketSymbolModel._(
      displayName: map['display_name'],
      id: map['symbol'],
      marketId: map['market'],
    );
  }
}
