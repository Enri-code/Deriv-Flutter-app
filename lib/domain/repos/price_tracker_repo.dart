import 'dart:async';

import 'package:deriv_test/core/utils/error_or.dart';
import 'package:deriv_test/core/utils/socket_response.dart';
import 'package:deriv_test/domain/entities/market.dart';

abstract class IPriceTrackerRepo {
  ///Gets all active symbols
  AsyncErrorOr<List<Market>> getSymbols();

  ///Gets the real-time ticks of a symbol as a Stream
  TicksResponse<Stream<String>> getTicks(String symbolId);
}
