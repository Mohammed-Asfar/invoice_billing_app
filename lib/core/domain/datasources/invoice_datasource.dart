import 'package:invoice_billing_app/core/entities/invoice.dart';
import 'package:invoice_billing_app/core/entities/user.dart';

/// Abstraction for invoice data operations.
abstract class InvoiceDatasource {
  /// Upload invoice data to the database.
  Future<String> uploadInvoiceData(
      {required Invoice invoice, required User user});

  /// Generate the next sequential invoice number.
  Future<String> getNextInvoiceNumber();

  /// Fetch all invoices, optionally filtered by a search string.
  Future<List<Invoice?>> getInvoices({String search = ""});

  /// Delete an invoice.
  Future<String> deleteInvoice(Invoice invoice);

  /// Update an existing invoice.
  Future<String> updateInvoice(Invoice invoice);

  /// Get invoice statistics (total count, this month's count).
  Future<Map<String, dynamic>> getInvoiceStats();
}
