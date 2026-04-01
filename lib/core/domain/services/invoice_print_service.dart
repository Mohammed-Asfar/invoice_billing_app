import 'package:invoice_billing_app/core/entities/invoice.dart';
import 'package:invoice_billing_app/core/entities/user.dart';

/// Abstraction for invoice printing/PDF generation.
abstract class InvoicePrintService {
  /// Generate an invoice PDF, save it, and open it.
  Future<String> printInvoice({
    required Invoice invoice,
    required User user,
  });
}
