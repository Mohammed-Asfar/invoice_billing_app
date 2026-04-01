import 'package:invoice_billing_app/core/entities/quotation.dart';
import 'package:invoice_billing_app/core/entities/user.dart';

/// Abstraction for quotation data operations.
abstract class QuotationDatasource {
  /// Upload quotation data to the database.
  Future<String> uploadQuotationData(
      {required Quotation quotation, required User user});

  /// Generate the next sequential quotation number.
  Future<String> getNextQuotationNumber();

  /// Fetch all quotations, optionally filtered by a search string.
  Future<List<Quotation?>> getQuotations({String search = ""});

  /// Delete a quotation.
  Future<String> deleteQuotation(Quotation quotation);

  /// Update an existing quotation.
  Future<String> updateQuotation(Quotation quotation);

  /// Get quotation statistics (total count, this month's count).
  Future<Map<String, dynamic>> getQuotationStats();
}
