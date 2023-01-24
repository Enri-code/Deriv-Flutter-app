import 'package:deriv_test/domain/entities/market.dart';

class MarketModel extends Market {
  MarketModel._({required super.name, required super.id});

  factory MarketModel.fromMap(Map<String, dynamic> map) {
    return MarketModel._(
      name: map['market_display_name'],
      id: map['market'],
    );
  }
}
