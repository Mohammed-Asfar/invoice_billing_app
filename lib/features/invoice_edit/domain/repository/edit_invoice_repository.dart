import 'package:fpdart/fpdart.dart';
import 'package:invoice_billing_app/core/domain/datasources/invoice_datasource.dart';
import 'package:invoice_billing_app/core/entities/invoice.dart';
import 'package:invoice_billing_app/core/entities/user.dart';
import 'package:invoice_billing_app/core/error/failure.dart';
import 'package:invoice_billing_app/core/error/server_exception.dart';

class EditInvoiceRepository {
  final InvoiceDatasource _invoiceRemoteDatasource;

  EditInvoiceRepository({required InvoiceDatasource invoiceRemoteDatasource})
      : _invoiceRemoteDatasource = invoiceRemoteDatasource;

  Future<Either<Failure, String>> printInvoice(
      {required Invoice invoice, required User user}) async {
    try {
      await _invoiceRemoteDatasource.printInvoiceDocument(
          invoice: invoice, user: user);
      return right('Invoice printed successfully');
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

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

  Future<Either<Failure, String>> deleteInvoice(
      {required Invoice invoice}) async {
    try {
      final res = await _invoiceRemoteDatasource.deleteInvoice(invoice);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  Future<Either<Failure, String>> updateInvoice(
      {required Invoice invoice}) async {
    try {
      final res = await _invoiceRemoteDatasource.updateInvoice(invoice);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
