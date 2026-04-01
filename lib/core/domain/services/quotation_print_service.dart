import 'package:invoice_billing_app/core/entities/quotation.dart';
import 'package:invoice_billing_app/core/entities/user.dart';

/// Abstraction for quotation printing/PDF generation.
abstract class QuotationPrintService {
  /// Generate a quotation PDF, save it, and open it.
  Future<String> printQuotation({
    required Quotation quotation,
    required User user,
  });
}
