import 'dart:async';

import 'package:deriv_test/core/utils/error_or.dart';
import 'package:deriv_test/core/utils/socket_response.dart';
import 'package:deriv_test/domain/entities/market.dart';

abstract class IPriceTrackerRepo {
  AsyncErrorOr<Stream<List<Market>>> getSymbols();
  AsyncErrorOr<ResponseWithSubId<Stream<num>>> getTicks(String symbolId);
  AsyncErrorOr<void> forget(int requestId);
}
