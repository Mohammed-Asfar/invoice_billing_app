import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invoice_billing_app/core/domain/datasources/quotation_datasource.dart';
import 'package:invoice_billing_app/core/entities/quotation.dart';
import 'package:invoice_billing_app/core/entities/user.dart';
import 'package:invoice_billing_app/core/error/server_exception.dart';
import 'package:invoice_billing_app/core/models/quotation_model.dart';
import 'package:invoice_billing_app/core/network_handle/check_connection.dart';

class QuotationRemoteDatasource implements QuotationDatasource {
  final FirebaseFirestore _firestore;
  late CollectionReference<Map<String, dynamic>> collection =
      _firestore.collection("quotations");

  QuotationRemoteDatasource({required FirebaseFirestore firebaseFirestore})
      : _firestore = firebaseFirestore;

  @override
  Future<String> uploadQuotationData(
      {required Quotation quotation, required User user}) async {
    if (await checkConnection()) {
      throw ServerException("No Internet Connection.");
    }
    try {
      await collection
          .doc(quotation.quotationNumber)
          .set(QuotationModel.fromEntity(quotation).toMap());
      return 'Quotation saved successfully';
    } catch (e) {
      throw ServerException('Error saving Quotation: $e');
    }
  }

  @override
  Future<String> getNextQuotationNumber() async {
    if (await checkConnection()) {
      throw ServerException("No Internet Connection.");
    }
    try {
      final now = DateTime.now();
      final year = now.year;
      final month = now.month.toString().padLeft(2, '0');

      // Query quotations whose quotationNumber starts with the current year-month prefix
      final prefix = "Q-$year-$month";
      final snapshot = await collection
          .where('quotationNumber', isGreaterThanOrEqualTo: prefix)
          .where('quotationNumber', isLessThan: "${prefix}z")
          .get();

      List<int> quotationNumbers = snapshot.docs
          .map((doc) {
            final quotationNumber = doc.data()['quotationNumber'] as String?;
            if (quotationNumber != null) {
              final match = RegExp(r"Q-(\d{4})-(\d{2})(\d{2})$")
                  .firstMatch(quotationNumber);
              if (match != null) {
                return int.parse(match.group(3)!);
              }
            }
            return 0;
          })
          .where((n) => n > 0)
          .toList();

      int nextNumber = 1;

      if (quotationNumbers.isNotEmpty) {
        quotationNumbers.sort();
        nextNumber = quotationNumbers.last + 1;
      }

      final nextQuotationNumber =
          "Q-$year-$month${nextNumber.toString().padLeft(2, '0')}";

      return nextQuotationNumber;
    } catch (e) {
      throw ServerException('Error generating next quotation number: $e');
    }
  }

  @override
  Future<List<Quotation?>> getQuotations({String search = ""}) async {
    if (await checkConnection()) {
      throw ServerException("No Internet Connection.");
    }
    try {
      final snapshot = await collection.get();

      List<Quotation?> quotations = snapshot.docs.map((doc) {
        try {
          final res =
              QuotationModel.fromEntity(QuotationModel.fromMap(doc.data()));

          if (res.quotationNumber
                  .toLowerCase()
                  .contains(search.toLowerCase()) ||
              res.customerName.toLowerCase().contains(search.toLowerCase())) {
            return res;
          }
        } catch (_) {}
        return null;
      }).toList();

      quotations.removeWhere((element) => element == null);
      quotations
          .sort((a, b) => a!.quotationNumber.compareTo(b!.quotationNumber));
      quotations = quotations.reversed.toList();

      return quotations;
    } catch (e) {
      throw ServerException('Error fetching quotations: $e');
    }
  }

  @override
  Future<String> deleteQuotation(Quotation quotation) async {
    if (await checkConnection()) {
      throw ServerException("No Internet Connection.");
    }
    try {
      await collection.doc(quotation.quotationNumber).delete();
      return 'Quotation ${quotation.quotationNumber} deleted successfully.';
    } catch (e) {
      throw ServerException('Error deleting quotation: $e');
    }
  }

  @override
  Future<String> updateQuotation(Quotation quotation) async {
    if (await checkConnection()) {
      throw ServerException("No Internet Connection.");
    }
    try {
      await collection
          .doc(quotation.quotationNumber)
          .set(QuotationModel.fromEntity(quotation).toMap());
      return 'Quotation ${quotation.quotationNumber} updated successfully.';
    } catch (e) {
      throw ServerException('Error updating quotation: $e');
    }
  }

  /// Get quotation statistics: total count and this month's count
  @override
  Future<Map<String, dynamic>> getQuotationStats() async {
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
          final quotationDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
          if (quotationDate.month == currentMonth &&
              quotationDate.year == currentYear) {
            thisMonthCount++;
          }
        }
      }

      return {
        'totalCount': totalCount,
        'thisMonthCount': thisMonthCount,
      };
    } catch (e) {
      throw ServerException('Error fetching quotation stats: $e');
    }
  }
}
