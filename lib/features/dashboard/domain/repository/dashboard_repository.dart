import 'package:fpdart/fpdart.dart';
import 'package:invoice_billing_app/core/data/invoice_remote_datasource.dart';
import 'package:invoice_billing_app/core/data/quotation_remote_datasource.dart';
import 'package:invoice_billing_app/core/entities/invoice.dart';
import 'package:invoice_billing_app/core/error/failure.dart';
import 'package:invoice_billing_app/core/error/server_exception.dart';

class DashboardRepository {
  final InvoiceRemoteDatasource _invoiceRemoteDatasource;
  final QuotationRemoteDatasource _quotationRemoteDatasource;

  DashboardRepository({
    required InvoiceRemoteDatasource invoiceRemoteDatasource,
    required QuotationRemoteDatasource quotationRemoteDatasource,
  })  : _invoiceRemoteDatasource = invoiceRemoteDatasource,
        _quotationRemoteDatasource = quotationRemoteDatasource;

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

  Future<Either<Failure, Map<String, dynamic>>> getStats() async {
    try {
      final invoiceStats = await _invoiceRemoteDatasource.getInvoiceStats();
      final quotationStats =
          await _quotationRemoteDatasource.getQuotationStats();

      return right({
        'totalInvoices': invoiceStats['totalCount'],
        'totalQuotations': quotationStats['totalCount'],
        'thisMonthInvoices': invoiceStats['thisMonthCount'],
        'thisMonthQuotations': quotationStats['thisMonthCount'],
      });
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
