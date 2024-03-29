import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:deriv_test/core/utils/app_error.dart';
import 'package:deriv_test/core/utils/error_or.dart';
import 'package:deriv_test/core/utils/socket_response.dart';
import 'package:deriv_test/data/models/market.dart';
import 'package:deriv_test/data/models/market_symbol.dart';
import 'package:deriv_test/domain/entities/market.dart';
import 'package:deriv_test/domain/repos/price_tracker_repo.dart';
import 'package:deriv_test/domain/repos/price_tracker_service.dart';

class PriceTrackerRepoImpl extends IPriceTrackerRepo {
  PriceTrackerRepoImpl(this._service);
  final IPriceTrackerService _service;

  @override
  AsyncErrorOr<List<Market>> getSymbols() async {
    try {
      final data = await _service.getSymbols();

      //Gets all the markets in the response JSON
      final markets = data.map((e) => MarketModel.fromMap(e)).toSet();
      //Gets all the markets symbols in the response JSON
      final symbols = data.map((e) => MarketSymbolModel.fromMap(e)).toSet();

      //Gets the symbols for each unique market and stores in the market's symbols variable
      for (final market in markets) {
        market.symbols = symbols.where((symbol) {
          return symbol.marketId == market.id;
        }).toList();
      }

      return Right(markets.toList());
    } catch (e) {
      return Left(AppError(e.toString()));
    }
  }

  @override
  TicksResponse<Stream<String>> getTicks(String symbolId) {
    return _service.getTicks(symbolId);
  }
}
