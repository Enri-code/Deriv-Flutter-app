import 'package:deriv_test/core/utils/socket_response.dart';

abstract class IPriceTrackerService {
  Future<List> getSymbols();
  TicksResponse<Stream<num>> getTicks(String symbolId);
}
