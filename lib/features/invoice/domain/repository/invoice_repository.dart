import 'package:fpdart/fpdart.dart';
import 'package:invoice_billing_app/core/data/invoice_remote_datasource.dart';
import 'package:invoice_billing_app/core/entities/invoice.dart';
import 'package:invoice_billing_app/core/entities/user.dart';
import 'package:invoice_billing_app/core/error/failure.dart';
import 'package:invoice_billing_app/core/error/server_exception.dart';

class CreateInvoiceRepository {
  final InvoiceRemoteDatasource _invoiceRemoteDatasource;

  CreateInvoiceRepository(
      {required InvoiceRemoteDatasource invoiceRemoteDatasource})
      : _invoiceRemoteDatasource = invoiceRemoteDatasource;

  Future<Either<Failure, String>> createInvoice(
      {required Invoice invoice, required User user}) async {
    try {
      await _invoiceRemoteDatasource.uploadInvoiceData(
          invoice: invoice, user: user);
      return right('Invoice generated successfully');
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  Future<Either<Failure, String>> getNextInvoiceNumber() async {
    try {
      final res = await _invoiceRemoteDatasource.getNextInvoiceNumber();
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
