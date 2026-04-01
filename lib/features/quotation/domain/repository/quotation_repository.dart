import 'package:fpdart/fpdart.dart';
import 'package:invoice_billing_app/core/domain/datasources/quotation_datasource.dart';
import 'package:invoice_billing_app/core/domain/services/quotation_print_service.dart';
import 'package:invoice_billing_app/core/entities/quotation.dart';
import 'package:invoice_billing_app/core/entities/user.dart';
import 'package:invoice_billing_app/core/error/failure.dart';
import 'package:invoice_billing_app/core/error/server_exception.dart';

/// Repository for simple quotation queries and operations.
/// Create-with-print orchestration is handled by [CreateQuotationUseCase].
class QuotationRepository {
  final QuotationDatasource _quotationDatasource;
  final QuotationPrintService _quotationPrintService;

  QuotationRepository({
    required QuotationDatasource quotationRemoteDatasource,
    required QuotationPrintService quotationPrintService,
  })  : _quotationDatasource = quotationRemoteDatasource,
        _quotationPrintService = quotationPrintService;

  Future<Either<Failure, String>> getNextQuotationNumber() async {
    try {
      final result = await _quotationDatasource.getNextQuotationNumber();
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, List<Quotation?>>> getQuotations({
    String search = "",
  }) async {
    try {
      final result = await _quotationDatasource.getQuotations(search: search);
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, String>> deleteQuotation(Quotation quotation) async {
    try {
      final result = await _quotationDatasource.deleteQuotation(quotation);
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, String>> updateQuotation(Quotation quotation) async {
    try {
      final result = await _quotationDatasource.updateQuotation(quotation);
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, String>> printQuotation({
    required Quotation quotation,
    required User user,
  }) async {
    try {
      final result = await _quotationPrintService.printQuotation(
        quotation: quotation,
        user: user,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
