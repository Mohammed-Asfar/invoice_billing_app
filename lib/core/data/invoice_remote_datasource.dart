import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invoice_billing_app/core/domain/datasources/invoice_datasource.dart';
import 'package:invoice_billing_app/core/entities/invoice.dart';
import 'package:invoice_billing_app/core/entities/user.dart';
import 'package:invoice_billing_app/core/error/server_exception.dart';
import 'package:invoice_billing_app/core/models/invoice_model.dart';
import 'package:invoice_billing_app/core/network_handle/check_connection.dart';

class InvoiceRemoteDatasource implements InvoiceDatasource {
  final FirebaseFirestore _firestore;
  late CollectionReference<Map<String, dynamic>> collection =
      _firestore.collection("invoices");

  InvoiceRemoteDatasource({required FirebaseFirestore firebaseFirestore})
      : _firestore = firebaseFirestore;

  /// Firestore doc IDs cannot contain '/'. Replace '/' with '_' for storage.
  String _docId(String invoiceNumber) => invoiceNumber.replaceAll('/', '_');

  @override
  Future<String> uploadInvoiceData(
      {required Invoice invoice, required User user}) async {
    if (await checkConnection()) {
      throw ServerException("No Internet Connection.");
    }
    try {
      await collection
          .doc(_docId(invoice.invoiceNumber))
          .set(InvoiceModel.fromEntity(invoice).toMap());
      return 'Invoice saved successfully';
    } catch (e) {
      throw ServerException('Error saving Invoice');
    }
  }

  /// Returns the financial year prefix like "25-26" or "26-27".
  /// FY runs April to March: Apr 2026 – Mar 2027 = "26-27".
  String _financialYearPrefix(DateTime date) {
    final startYear = date.month >= 4 ? date.year : date.year - 1;
    final endYear = startYear + 1;
    return '${startYear % 100}-${endYear % 100}';
  }

  @override
  Future<String> getNextInvoiceNumber() async {
    if (await checkConnection()) {
      throw ServerException("No Internet Connection.");
    }
    try {
      final now = DateTime.now();
      final fyPrefix = _financialYearPrefix(now);

      // Query invoices with the current financial year prefix (e.g. "26-27/")
      final snapshot = await collection
          .where('invoiceNumber', isGreaterThanOrEqualTo: '$fyPrefix/')
          .where('invoiceNumber', isLessThan: '$fyPrefix/z')
          .get();

      List<int> invoiceNumbers = snapshot.docs
          .map((doc) {
            final invoiceNumber = doc.data()['invoiceNumber'] as String?;
            if (invoiceNumber != null) {
              // Match "YY-YY/NNN" format
              final match =
                  RegExp(r"\d{2}-\d{2}/(\d+)$").firstMatch(invoiceNumber);
              if (match != null) {
                return int.parse(match.group(1)!);
              }
            }
            return 0;
          })
          .where((n) => n > 0)
          .toList();

      int nextNumber = 1;

      if (invoiceNumbers.isNotEmpty) {
        invoiceNumbers.sort();
        nextNumber = invoiceNumbers.last + 1;
      }

      // Format: "26-27/001"
      final nextInvoiceNumber =
          '$fyPrefix/${nextNumber.toString().padLeft(3, '0')}';

      return nextInvoiceNumber;
    } catch (e) {
      throw ServerException('Error generating next invoice number: $e');
    }
  }

  @override
  Future<List<Invoice?>> getInvoices({String search = ""}) async {
    if (await checkConnection()) {
      throw ServerException("No Internet Connection.");
    }
    try {
      final snapshot = await collection.get();

      List<Invoice?> invoices = snapshot.docs.map((doc) {
        try {
          final res = InvoiceModel.fromEntity(InvoiceModel.fromMap(doc.data()));
          if (res.invoiceNumber.contains(search)) {
            return res;
          }
        } catch (_) {}
        return null;
      }).toList();

      invoices.removeWhere((element) => element == null);
      invoices.sort((a, b) => a!.invoiceNumber.compareTo(b!.invoiceNumber));
      invoices = invoices.reversed.toList();

      return invoices;
    } catch (e) {
      throw ServerException('Error fetching invoices: $e');
    }
  }

  @override
  Future<String> deleteInvoice(Invoice invoice) async {
    if (await checkConnection()) {
      throw ServerException("No Internet Connection.");
    }
    try {
      await collection.doc(_docId(invoice.invoiceNumber)).delete();
      return 'Invoice ${invoice.invoiceNumber} deleted successfully.';
    } catch (e) {
      throw ServerException('Error deleting invoice: $e');
    }
  }

  @override
  Future<String> updateInvoice(Invoice invoice) async {
    if (await checkConnection()) {
      throw ServerException("No Internet Connection.");
    }
    try {
      await collection
          .doc(_docId(invoice.invoiceNumber))
          .set(InvoiceModel.fromEntity(invoice).toMap());
      return 'Invoice ${invoice.invoiceNumber} updated successfully.';
    } catch (e) {
      throw ServerException('Error update invoice: $e');
    }
  }

  /// Get invoice statistics: total count and this month's count
  @override
  Future<Map<String, dynamic>> getInvoiceStats() async {
    if (await checkConnection()) {
      throw ServerException("No Internet Connection.");
    }
    try {
      final now = DateTime.now();
      final currentMonth = now.month;
      final currentYear = now.year;

      final snapshot = await collection.get();

      int totalCount = 0;
      int thisMonthCount = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        totalCount++;

        final issuedDate = data['issuedDate'];
        if (issuedDate != null) {
          int timestamp =
              issuedDate is int ? issuedDate : (issuedDate as num).toInt();
          final invoiceDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
          if (invoiceDate.month == currentMonth &&
              invoiceDate.year == currentYear) {
            thisMonthCount++;
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
