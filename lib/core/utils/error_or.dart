import 'package:dartz/dartz.dart';
import 'package:deriv_test/core/utils/app_error.dart';

typedef AsyncErrorOr<T> = Future<Either<AppError, T>>;
