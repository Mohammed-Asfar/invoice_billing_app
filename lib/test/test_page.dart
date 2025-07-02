import 'dart:io';
import 'package:flutter/material.dart';
import 'package:invoice_billing_app/test/test.dart';
import 'package:path_provider/path_provider.dart';

class InvoiceApp extends StatelessWidget {
  const InvoiceApp({super.key});

  Future<void> generateAndOpenPdf() async {
    // Generate PDF
    final pdfData = await generateInvoicePdf1(); // Use your function here

    // Save PDF locally
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}\\invoice.pdf';
    final file = File(filePath);
    await file.writeAsBytes(pdfData);

    // Open PDF
    Process.run('explorer.exe', [filePath]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Generator'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: generateAndOpenPdf,
          child: Text('Generate and Open Invoice'),
        ),
      ),
    );
  }
}
