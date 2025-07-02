// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:invoice_billing_app/core/utils/templates/invoice_templates.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:invoice_billing_app/core/entities/invoice.dart';
import 'package:invoice_billing_app/core/entities/user.dart';

Future<void> printInvoice(
    {required Invoice invoice, required User user}) async {
  final pdfData =
      await generatefinalClassicInvoicePDF(invoice: invoice, user: user);

  final directory = await getApplicationDocumentsDirectory();
  final folderPath = path.join(directory.path, 'Invoice Documents');

  final folder = Directory(folderPath);
  if (!await folder.exists()) {
    await folder.create(recursive: true);
  }

  final filePath =
      path.join(folderPath, 'invoice_${invoice.invoiceNumber}.pdf');
  final file = File(filePath);
  await file.writeAsBytes(pdfData);

  Process.run('explorer.exe', [filePath]);
}
