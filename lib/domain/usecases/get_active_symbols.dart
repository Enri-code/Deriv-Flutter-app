import 'package:deriv_test/core/utils/error_or.dart';
import 'package:deriv_test/core/utils/use_case_base.dart';
import 'package:deriv_test/domain/entities/market.dart';
import 'package:deriv_test/domain/repos/price_tracker_repo.dart';

class GetActiveSymbols extends UseCase<List<Market>> {
  final IPriceTrackerRepo _repo;

  const GetActiveSymbols(this._repo);

  @override
  AsyncErrorOr<List<Market>> call() => _repo.getSymbols();
}
