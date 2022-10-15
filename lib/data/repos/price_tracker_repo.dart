import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:deriv_test/core/services/id_generator.dart';
import 'package:deriv_test/core/services/socket.dart';
import 'package:deriv_test/core/utils/app_error.dart';
import 'package:deriv_test/core/utils/error_or.dart';
import 'package:deriv_test/core/utils/socket_response.dart';
import 'package:deriv_test/data/models/market.dart';
import 'package:deriv_test/data/models/market_symbol.dart';
import 'package:deriv_test/domain/entities/market.dart';
import 'package:deriv_test/domain/repos/price_tracker_repo.dart';

class PriceTrackerRepoImpl extends IPriceTrackerRepo {
  PriceTrackerRepoImpl();

  final _ticksStream = StreamController<num>.broadcast();
  StreamSubscription? _ticksSub;

  @override
  AsyncErrorOr<Stream<List<Market>>> getSymbols() async {
    try {
      final parameters = jsonEncode({
        "active_symbols": "brief",
        "product_type": "basic",
        "req_id": IDGenerator.random(),
      });

      SocketConnection.sink.add(parameters);
/*       dynamic data;
      await SocketConnection.stream.forEach((element) => data = element);
      data = jsonDecode(data); */
      final data = jsonDecode(await SocketConnection.stream.first);
      final activeSymbols = data['active_symbols'] as List;
      final markets = activeSymbols.map((e) => MarketModel.fromMap(e)).toSet();
      final symbols =
          activeSymbols.map((e) => MarketSymbolModel.fromMap(e)).toSet();

      //Gets the symbols for each market and stores in the market's symbols variable
      for (final market in markets) {
        market.symbols = symbols.where((symbol) {
          return symbol.marketId == market.marketId;
        }).toList();
      }
      return Right(Stream.value(markets.toList()));
    } catch (e) {
      return const Left(AppError());
    }
  }

  @override
  AsyncErrorOr<ResponseWithSubId<Stream<num>>> getTicks(String symbolId) async {
    try {
      final parameters = jsonEncode({
        'ticks': symbolId,
        "req_id": IDGenerator.random(),
      });
      SocketConnection.sink.add(parameters);

      _ticksSub?.cancel();
      _ticksSub = SocketConnection.stream.listen((event) {
        final newData = jsonDecode(event);
        if (newData['tick'] != null) _ticksStream.add(newData['tick']['quote']);
      });

      final data = jsonDecode(await SocketConnection.stream.first);
      if (data['error'] != null)
        return Left(AppError(data['error']['message']));
      return Right(
        ResponseWithSubId(
          data: _ticksStream.stream.asBroadcastStream(),
          requestId: data['req_id'],
        ),
      );
    } catch (e) {
      return const Left(AppError());
    }
  }

  @override
  AsyncErrorOr<void> forget(int requestId) async {
    try {
      final parameters = jsonEncode({"forget": requestId});
      SocketConnection.sink.add(parameters);
      return const Right(null);
    } catch (e) {
      return const Left(AppError());
    }
  }
}
