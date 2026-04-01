import 'package:fpdart/fpdart.dart';
import 'package:invoice_billing_app/core/domain/datasources/quotation_datasource.dart';
import 'package:invoice_billing_app/core/domain/services/quotation_print_service.dart';
import 'package:invoice_billing_app/core/domain/usecase/usecase.dart';
import 'package:invoice_billing_app/core/entities/quotation.dart';
import 'package:invoice_billing_app/core/entities/user.dart';
import 'package:invoice_billing_app/core/error/failure.dart';
import 'package:invoice_billing_app/core/error/server_exception.dart';

/// Parameters for the [CreateQuotationUseCase].
class CreateQuotationParams {
  final Quotation quotation;
  final User user;

  CreateQuotationParams({required this.quotation, required this.user});
}

/// Orchestrates creating a quotation: save to database, then generate PDF.
class CreateQuotationUseCase extends UseCase<String, CreateQuotationParams> {
  final QuotationDatasource _quotationDatasource;
  final QuotationPrintService _quotationPrintService;

  CreateQuotationUseCase({
    required QuotationDatasource quotationDatasource,
    required QuotationPrintService quotationPrintService,
  })  : _quotationDatasource = quotationDatasource,
        _quotationPrintService = quotationPrintService;

  @override
  Future<Either<Failure, String>> call(CreateQuotationParams params) async {
    try {
      await _quotationDatasource.uploadQuotationData(
        quotation: params.quotation,
        user: params.user,
      );
      await _quotationPrintService.printQuotation(
        quotation: params.quotation,
        user: params.user,
      );
      return right('Quotation generated successfully');
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
