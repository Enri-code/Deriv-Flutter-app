import 'package:deriv_test/core/utils/error_or.dart';
import 'package:deriv_test/core/utils/use_case_base.dart';
import 'package:deriv_test/domain/repos/price_tracker_repo.dart';

class Forget extends UseCase<void> {
  final IPriceTrackerRepo _repo;
  final int requestId;

  const Forget(this._repo, {required this.requestId});

  @override
  AsyncErrorOr<void> call() => _repo.forget(requestId);
}
