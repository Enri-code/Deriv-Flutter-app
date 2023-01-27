import 'package:deriv_test/core/utils/socket_response.dart';
import 'package:deriv_test/core/utils/use_case_base.dart';
import 'package:deriv_test/domain/repos/price_tracker_repo.dart';

class GetPriceTicks extends UseCase<TicksResponse<Stream<String>>> {
  final IPriceTrackerRepo _repo;
  final String symbol;

  const GetPriceTicks(this._repo, {required this.symbol});

  @override
  TicksResponse<Stream<String>> call() => _repo.getTicks(symbol);
}
