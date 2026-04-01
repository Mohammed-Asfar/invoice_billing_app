import 'package:fpdart/fpdart.dart';
import 'package:invoice_billing_app/core/error/failure.dart';

/// Base class for all use cases.
/// [ReturnType] is the return type, [Params] is the input parameter type.
abstract class UseCase<ReturnType, Params> {
  Future<Either<Failure, ReturnType>> call(Params params);
}

/// Sentinel class for use cases that take no parameters.
class NoParams {}
