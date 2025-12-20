import 'package:invoice_billing_app/core/entities/invoice.dart';
import 'package:invoice_billing_app/core/entities/user.dart';
import 'package:invoice_billing_app/core/error/server_exception.dart';
import 'package:invoice_billing_app/core/models/invoice_model.dart';
import 'package:invoice_billing_app/core/network_handle/check_connection.dart';
import 'package:invoice_billing_app/core/utils/print_invoice.dart';
import 'package:mongo_dart/mongo_dart.dart';

class InvoiceRemoteDatasource {
  final Db _mongoDb;
  late DbCollection collection = _mongoDb.collection("dataBase");

  InvoiceRemoteDatasource({required Db mongoDb}) : _mongoDb = mongoDb;

  Future<String> printInvoiceDocument(
      {required Invoice invoice, required User user}) async {
    if (await checkConnection()) {
      throw ServerException("No Internet Connection.");
    }
    try {
      await printInvoice(invoice: invoice, user: user);
      return 'Invoice generated successfully';
    } catch (e) {
      throw 'Error generating Invoice';
    }
  }

  Future<String> uploadInvoiceData(
      {required Invoice invoice, required User user}) async {
    if (await checkConnection()) {
      throw ServerException("No Internet Connection.");
    }
    try {
      await collection.insert({
        "_id": invoice.invoiceNumber,
        "invoice_${invoice.invoiceNumber}":
            InvoiceModel.fromEntity(invoice).toMap()
      });
      await printInvoiceDocument(invoice: invoice, user: user);
      return 'Invoice generated successfully';
    } catch (e) {
      throw ServerException('Error generating Invoice');
    }
  }

  Future<String> getNextInvoiceNumber() async {
    if (await checkConnection()) {
      throw ServerException("No Internet Connection.");
    }
    try {
      final now = DateTime.now();
      final year = now.year;
      final month = now.month.toString().padLeft(2, '0');

      // Fetch all invoice documents
      final latestInvoices = await collection.find().toList();

      // Extract invoice numbers in the format "invoice_YYYY-MMNN"
      List<int> invoiceNumbers = latestInvoices
          .map((doc) {
            final invoiceKey = doc.keys.firstWhere(
                (key) => key.startsWith("invoice_$year-$month"),
                orElse: () => "");
            if (invoiceKey.isNotEmpty) {
              final match =
                  RegExp(r"(\d{4})-(\d{2})(\d{2})$").firstMatch(invoiceKey);
              if (match != null) {
                return int.parse(match.group(3)!); // Extract last NN part
              }
            }
            return 0;
          })
          .where((num) => num > 0) // Remove invalid values
          .toList();

      int nextNumber = 1; // Default if no invoices exist

      if (invoiceNumbers.isNotEmpty) {
        // Sort numerically
        invoiceNumbers.sort();
        nextNumber = invoiceNumbers.last + 1;
      }

      // Format as "YYYY-MMNN" (e.g., 2025-0101, 2025-0110)
      final nextInvoiceNumber =
          "$year-$month${nextNumber.toString().padLeft(2, '0')}";

      return nextInvoiceNumber;
    } catch (e) {
      throw ServerException('Error generating next invoice number: $e');
    }
  }

  Future<List<Invoice?>> getInvoices({String search = ""}) async {
    if (await checkConnection()) {
      throw ServerException("No Internet Connection.");
    }
    try {
      // Assume we're fetching data from some external source or database.
      List<Map<String, dynamic>> queryResults;

      queryResults = await collection.find().toList();

      // Map the query result to a list of Invoice objects
      List<Invoice?> invoices = queryResults.map((doc) {
        final invoiceKey = doc.keys
            .firstWhere((key) => key.startsWith("invoice_"), orElse: () => "");

        if (invoiceKey.isNotEmpty) {
          final res =
              InvoiceModel.fromEntity(InvoiceModel.fromMap(doc[invoiceKey]));

          if (res.invoiceNumber.contains(search)) {
            return res;
          }
        }
      }).toList();

      invoices.removeWhere(
        (element) {
          return element == null;
        },
      );

      invoices.sort((a, b) => a!.invoiceNumber.compareTo(b!.invoiceNumber));
      invoices = invoices.reversed.toList();

      return invoices;
    } catch (e) {
      throw ServerException('Error fetching invoices: $e');
    }
  }

  Future<String> deleteInvoice(Invoice invoice) async {
    if (await checkConnection()) {
      throw ServerException("No Internet Connection.");
    }
    try {
      // Find and delete the invoice from the database

      await collection.deleteOne({"_id": invoice.invoiceNumber},
          collation: CollationOptions('fr', strength: 1));

      // Optionally, show a success message
      return 'Invoice ${invoice.invoiceNumber} deleted successfully.';
    } catch (e) {
      throw ServerException('Error deleting invoice: $e');
    }
  }

  Future<String> updateInvoice(Invoice invoice) async {
    if (await checkConnection()) {
      throw ServerException("No Internet Connection.");
    }
    try {
      await collection.replaceOne({
        "_id": invoice.invoiceNumber
      }, {
        "invoice_${invoice.invoiceNumber}":
            InvoiceModel.fromEntity(invoice).toMap()
      });

      // Optionally, show a success message
      return 'Invoice ${invoice.invoiceNumber} updated successfully.';
    } catch (e) {
      throw ServerException('Error update invoice: $e');
    }
  }

  /// Get invoice statistics: total count and this month's count
  Future<Map<String, dynamic>> getInvoiceStats() async {
    if (await checkConnection()) {
      throw ServerException("No Internet Connection.");
    }
    try {
      final now = DateTime.now();
      final currentMonth = now.month;
      final currentYear = now.year;

      final queryResults = await collection.find().toList();

      int totalCount = 0;
      int thisMonthCount = 0;

      for (var doc in queryResults) {
        final invoiceKey = doc.keys
            .firstWhere((key) => key.startsWith("invoice_"), orElse: () => "");

        if (invoiceKey.isNotEmpty) {
          final invoiceData = doc[invoiceKey];
          totalCount++;

          // Check if this month's invoice
          final issuedDate = invoiceData['issuedDate'];
          if (issuedDate != null) {
            int timestamp = issuedDate is int
                ? issuedDate
                : (issuedDate as dynamic).toInt();
            final invoiceDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
            if (invoiceDate.month == currentMonth &&
                invoiceDate.year == currentYear) {
              thisMonthCount++;
            }
          }
        }
      }

      return {
        'totalCount': totalCount,
        'thisMonthCount': thisMonthCount,
      };
    } catch (e) {
      throw ServerException('Error fetching invoice stats: $e');
    }
  }
}
