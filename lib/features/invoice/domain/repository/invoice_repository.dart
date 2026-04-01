import 'package:fpdart/fpdart.dart';
import 'package:invoice_billing_app/core/domain/datasources/invoice_datasource.dart';
import 'package:invoice_billing_app/core/error/failure.dart';
import 'package:invoice_billing_app/core/error/server_exception.dart';

/// Repository for simple invoice queries (no orchestration).
/// Create-with-print is handled by [CreateInvoiceUseCase].
class CreateInvoiceRepository {
  final InvoiceDatasource _invoiceDatasource;

  CreateInvoiceRepository({
    required InvoiceDatasource invoiceRemoteDatasource,
  }) : _invoiceDatasource = invoiceRemoteDatasource;

  Future<Either<Failure, String>> getNextInvoiceNumber() async {
    try {
      final res = await _invoiceDatasource.getNextInvoiceNumber();
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
