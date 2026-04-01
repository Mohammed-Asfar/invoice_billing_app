import 'package:fpdart/fpdart.dart';
import 'package:invoice_billing_app/core/domain/datasources/invoice_datasource.dart';
import 'package:invoice_billing_app/core/domain/services/invoice_print_service.dart';
import 'package:invoice_billing_app/core/domain/usecase/usecase.dart';
import 'package:invoice_billing_app/core/entities/invoice.dart';
import 'package:invoice_billing_app/core/entities/user.dart';
import 'package:invoice_billing_app/core/error/failure.dart';
import 'package:invoice_billing_app/core/error/server_exception.dart';

/// Parameters for the [CreateInvoiceUseCase].
class CreateInvoiceParams {
  final Invoice invoice;
  final User user;

  CreateInvoiceParams({required this.invoice, required this.user});
}

/// Orchestrates creating an invoice: save to database, then generate PDF.
class CreateInvoiceUseCase extends UseCase<String, CreateInvoiceParams> {
  final InvoiceDatasource _invoiceDatasource;
  final InvoicePrintService _invoicePrintService;

  CreateInvoiceUseCase({
    required InvoiceDatasource invoiceDatasource,
    required InvoicePrintService invoicePrintService,
  })  : _invoiceDatasource = invoiceDatasource,
        _invoicePrintService = invoicePrintService;

  @override
  Future<Either<Failure, String>> call(CreateInvoiceParams params) async {
    try {
      await _invoiceDatasource.uploadInvoiceData(
        invoice: params.invoice,
        user: params.user,
      );
      await _invoicePrintService.printInvoice(
        invoice: params.invoice,
        user: params.user,
      );
      return right('Invoice generated successfully');
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
