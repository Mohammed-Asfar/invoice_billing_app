import 'dart:io';
import 'package:invoice_billing_app/core/domain/services/quotation_print_service.dart';
import 'package:invoice_billing_app/core/entities/quotation.dart';
import 'package:invoice_billing_app/core/entities/user.dart';
import 'package:invoice_billing_app/core/error/server_exception.dart';
import 'package:invoice_billing_app/core/utils/templates/quotation_template.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Concrete implementation of [QuotationPrintService].
/// Generates a PDF and opens it with the system viewer.
class QuotationPrintServiceImpl implements QuotationPrintService {
  @override
  Future<String> printQuotation({
    required Quotation quotation,
    required User user,
  }) async {
    try {
      final pdfData =
          await generateQuotationPDF(user: user, quotation: quotation);

      final directory = await getApplicationDocumentsDirectory();
      final folderPath = path.join(directory.path, 'Quotation Documents');

      final folder = Directory(folderPath);
      if (!await folder.exists()) {
        await folder.create(recursive: true);
      }

      final safeNumber = quotation.quotationNumber.replaceAll('/', '_');
      final filePath =
          path.join(folderPath, 'quotation_$safeNumber.pdf');
      final file = File(filePath);
      await file.writeAsBytes(pdfData);

      await Process.run('explorer.exe', [filePath]);

      return 'Quotation generated successfully';
    } catch (e) {
      throw ServerException('Error generating Quotation: $e');
    }
  }
}
