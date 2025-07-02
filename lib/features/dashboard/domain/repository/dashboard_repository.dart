import 'package:fpdart/fpdart.dart';
import 'package:invoice_billing_app/core/data/invoice_remote_datasource.dart';
import 'package:invoice_billing_app/core/entities/invoice.dart';
import 'package:invoice_billing_app/core/error/failure.dart';
import 'package:invoice_billing_app/core/error/server_exception.dart';

class DashboardRepository {
  final InvoiceRemoteDatasource _invoiceRemoteDatasource;

  DashboardRepository(
      {required InvoiceRemoteDatasource invoiceRemoteDatasource})
      : _invoiceRemoteDatasource = invoiceRemoteDatasource;

  Future<Either<Failure, List<Invoice>>> getInvoices(
      {String search = ""}) async {
    try {
      final List<Invoice?> res =
          await _invoiceRemoteDatasource.getInvoices(search: search);
      if (res.isEmpty) {
        return left(Failure("No invoices found"));
      }
      return right(res.whereType<Invoice>().toList());
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
