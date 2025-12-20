import 'package:fpdart/fpdart.dart';
import 'package:invoice_billing_app/core/data/quotation_remote_datasource.dart';
import 'package:invoice_billing_app/core/entities/quotation.dart';
import 'package:invoice_billing_app/core/entities/user.dart';
import 'package:invoice_billing_app/core/error/failure.dart';
import 'package:invoice_billing_app/core/error/server_exception.dart';

class QuotationRepository {
  final QuotationRemoteDatasource quotationRemoteDatasource;

  QuotationRepository({required this.quotationRemoteDatasource});

  Future<Either<Failure, String>> uploadQuotation({
    required Quotation quotation,
    required User user,
  }) async {
    try {
      final result = await quotationRemoteDatasource.uploadQuotationData(
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

  Future<Either<Failure, String>> getNextQuotationNumber() async {
    try {
      final result = await quotationRemoteDatasource.getNextQuotationNumber();
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
      final result =
          await quotationRemoteDatasource.getQuotations(search: search);
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, String>> deleteQuotation(Quotation quotation) async {
    try {
      final result = await quotationRemoteDatasource.deleteQuotation(quotation);
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, String>> updateQuotation(Quotation quotation) async {
    try {
      final result = await quotationRemoteDatasource.updateQuotation(quotation);
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
      final result = await quotationRemoteDatasource.printQuotationDocument(
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
