// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:invoice_billing_app/core/domain/services/invoice_print_service.dart';
import 'package:invoice_billing_app/core/entities/invoice.dart';
import 'package:invoice_billing_app/core/entities/user.dart';
import 'package:invoice_billing_app/core/error/server_exception.dart';
import 'package:invoice_billing_app/core/utils/templates/invoice_templates.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Concrete implementation of [InvoicePrintService].
/// Generates a PDF and opens it with the system viewer.
class InvoicePrintServiceImpl implements InvoicePrintService {
  @override
  Future<String> printInvoice({
    required Invoice invoice,
    required User user,
  }) async {
    try {
      final pdfData =
          await generatefinalClassicInvoicePDF(invoice: invoice, user: user);

      final directory = await getApplicationDocumentsDirectory();
      final folderPath = path.join(directory.path, 'Invoice Documents');

      final folder = Directory(folderPath);
      if (!await folder.exists()) {
        await folder.create(recursive: true);
      }

      final safeNumber = invoice.invoiceNumber.replaceAll('/', '_');
      final filePath =
          path.join(folderPath, 'invoice_$safeNumber.pdf');
      final file = File(filePath);
      await file.writeAsBytes(pdfData);

      await Process.run('explorer.exe', [filePath]);

      return 'Invoice generated successfully';
    } catch (e) {
      throw ServerException('Error generating Invoice: $e');
    }
  }
}
