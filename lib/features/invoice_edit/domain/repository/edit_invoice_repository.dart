import 'package:fpdart/fpdart.dart';
import 'package:invoice_billing_app/core/domain/datasources/invoice_datasource.dart';
import 'package:invoice_billing_app/core/domain/services/invoice_print_service.dart';
import 'package:invoice_billing_app/core/entities/invoice.dart';
import 'package:invoice_billing_app/core/entities/user.dart';
import 'package:invoice_billing_app/core/error/failure.dart';
import 'package:invoice_billing_app/core/error/server_exception.dart';

/// Repository for edit-related invoice operations.
/// Create-with-print orchestration is handled by [CreateInvoiceUseCase].
class EditInvoiceRepository {
  final InvoiceDatasource _invoiceDatasource;
  final InvoicePrintService _invoicePrintService;

  EditInvoiceRepository({
    required InvoiceDatasource invoiceRemoteDatasource,
    required InvoicePrintService invoicePrintService,
  })  : _invoiceDatasource = invoiceRemoteDatasource,
        _invoicePrintService = invoicePrintService;

  Future<Either<Failure, String>> printInvoice(
      {required Invoice invoice, required User user}) async {
    try {
      await _invoicePrintService.printInvoice(invoice: invoice, user: user);
      return right('Invoice printed successfully');
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  Future<Either<Failure, String>> deleteInvoice(
      {required Invoice invoice}) async {
    try {
      final res = await _invoiceDatasource.deleteInvoice(invoice);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  Future<Either<Failure, String>> updateInvoice(
      {required Invoice invoice}) async {
    try {
      final res = await _invoiceDatasource.updateInvoice(invoice);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
