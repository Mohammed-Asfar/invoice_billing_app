import 'package:invoice_billing_app/core/entities/quotation.dart';
import 'package:invoice_billing_app/core/entities/user.dart';
import 'package:invoice_billing_app/core/error/server_exception.dart';
import 'package:invoice_billing_app/core/models/quotation_model.dart';
import 'package:invoice_billing_app/core/network_handle/check_connection.dart';
import 'package:invoice_billing_app/core/utils/templates/quotation_template.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class QuotationRemoteDatasource {
  final Db _mongoDb;
  late DbCollection collection = _mongoDb.collection("quotations");

  QuotationRemoteDatasource({required Db mongoDb}) : _mongoDb = mongoDb;

  Future<String> printQuotationDocument(
      {required Quotation quotation, required User user}) async {
    if (await checkConnection()) {
      throw ServerException("No Internet Connection.");
    }
    try {
      // Generate PDF
      final pdfData =
          await generateQuotationPDF(user: user, quotation: quotation);

      // Save PDF to file
      final directory = await getApplicationDocumentsDirectory();
      final folderPath = path.join(directory.path, 'Quotation Documents');

      final folder = Directory(folderPath);
      if (!await folder.exists()) {
        await folder.create(recursive: true);
      }

      final filePath =
          path.join(folderPath, 'quotation_${quotation.quotationNumber}.pdf');
      final file = File(filePath);
      await file.writeAsBytes(pdfData);

      // Open the file
      await Process.run('explorer.exe', [filePath]);

      return 'Quotation generated successfully';
    } catch (e) {
      throw ServerException('Error generating Quotation: $e');
    }
  }

  Future<String> uploadQuotationData(
      {required Quotation quotation, required User user}) async {
    if (await checkConnection()) {
      throw ServerException("No Internet Connection.");
    }
    try {
      await collection.insert({
        "_id": quotation.quotationNumber,
        "quotation_${quotation.quotationNumber}":
            QuotationModel.fromEntity(quotation).toMap()
      });
      await printQuotationDocument(quotation: quotation, user: user);
      return 'Quotation generated successfully';
    } catch (e) {
      throw ServerException('Error generating Quotation: $e');
    }
  }

  Future<String> getNextQuotationNumber() async {
    if (await checkConnection()) {
      throw ServerException("No Internet Connection.");
    }
    try {
      final now = DateTime.now();
      final year = now.year;
      final month = now.month.toString().padLeft(2, '0');

      // Fetch all quotation documents
      final latestQuotations = await collection.find().toList();

      // Extract quotation numbers in the format "quotation_Q-YYYY-MMNN"
      List<int> quotationNumbers = latestQuotations
          .map((doc) {
            final quotationKey = doc.keys.firstWhere(
                (key) => key.startsWith("quotation_Q-$year-$month"),
                orElse: () => "");
            if (quotationKey.isNotEmpty) {
              final match =
                  RegExp(r"Q-(\d{4})-(\d{2})(\d{2})$").firstMatch(quotationKey);
              if (match != null) {
                return int.parse(match.group(3)!); // Extract last NN part
              }
            }
            return 0;
          })
          .where((num) => num > 0) // Remove invalid values
          .toList();

      int nextNumber = 1; // Default if no quotations exist

      if (quotationNumbers.isNotEmpty) {
        // Sort numerically
        quotationNumbers.sort();
        nextNumber = quotationNumbers.last + 1;
      }

      // Format as "Q-YYYY-MMNN" (e.g., Q-2025-0101, Q-2025-0110)
      final nextQuotationNumber =
          "Q-$year-$month${nextNumber.toString().padLeft(2, '0')}";

      return nextQuotationNumber;
    } catch (e) {
      throw ServerException('Error generating next quotation number: $e');
    }
  }

  Future<List<Quotation?>> getQuotations({String search = ""}) async {
    if (await checkConnection()) {
      throw ServerException("No Internet Connection.");
    }
    try {
      List<Map<String, dynamic>> queryResults;

      queryResults = await collection.find().toList();

      // Map the query result to a list of Quotation objects
      List<Quotation?> quotations = queryResults.map((doc) {
        final quotationKey = doc.keys.firstWhere(
            (key) => key.startsWith("quotation_"),
            orElse: () => "");

        if (quotationKey.isNotEmpty) {
          final res = QuotationModel.fromEntity(
              QuotationModel.fromMap(doc[quotationKey]));

          if (res.quotationNumber
                  .toLowerCase()
                  .contains(search.toLowerCase()) ||
              res.customerName.toLowerCase().contains(search.toLowerCase())) {
            return res;
          }
        }
        return null;
      }).toList();

      quotations.removeWhere(
        (element) {
          return element == null;
        },
      );

      quotations
          .sort((a, b) => a!.quotationNumber.compareTo(b!.quotationNumber));
      quotations = quotations.reversed.toList();

      return quotations;
    } catch (e) {
      throw ServerException('Error fetching quotations: $e');
    }
  }

  Future<String> deleteQuotation(Quotation quotation) async {
    if (await checkConnection()) {
      throw ServerException("No Internet Connection.");
    }
    try {
      await collection.deleteOne({"_id": quotation.quotationNumber},
          collation: CollationOptions('fr', strength: 1));

      return 'Quotation ${quotation.quotationNumber} deleted successfully.';
    } catch (e) {
      throw ServerException('Error deleting quotation: $e');
    }
  }

  Future<String> updateQuotation(Quotation quotation) async {
    if (await checkConnection()) {
      throw ServerException("No Internet Connection.");
    }
    try {
      await collection.replaceOne({
        "_id": quotation.quotationNumber
      }, {
        "quotation_${quotation.quotationNumber}":
            QuotationModel.fromEntity(quotation).toMap()
      });

      return 'Quotation ${quotation.quotationNumber} updated successfully.';
    } catch (e) {
      throw ServerException('Error updating quotation: $e');
    }
  }

  /// Get quotation statistics: total count and this month's count
  Future<Map<String, dynamic>> getQuotationStats() async {
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
        final quotationKey = doc.keys.firstWhere(
            (key) => key.startsWith("quotation_"),
            orElse: () => "");

        if (quotationKey.isNotEmpty) {
          final quotationData = doc[quotationKey];
          totalCount++;

          // Check if this month's quotation
          final issuedDate = quotationData['issuedDate'];
          if (issuedDate != null) {
            int timestamp = issuedDate is int
                ? issuedDate
                : (issuedDate as dynamic).toInt();
            final quotationDate =
                DateTime.fromMillisecondsSinceEpoch(timestamp);
            if (quotationDate.month == currentMonth &&
                quotationDate.year == currentYear) {
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
      throw ServerException('Error fetching quotation stats: $e');
    }
  }
}
