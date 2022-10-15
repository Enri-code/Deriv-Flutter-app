import 'package:deriv_test/core/utils/error_or.dart';

/// Base interface for use cases, to ensure predictability
abstract class UseCase<T> {
  const UseCase();
  AsyncErrorOr<T> call();
}
