import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:invoice_billing_app/core/entities/invoice.dart';
import 'package:invoice_billing_app/core/entities/user.dart';
import 'package:invoice_billing_app/core/utils/date_format.dart';
part 'final_invoice_template.dart';

// Helper function for Table Cells
pw.Widget _tableCell(String text,
    {bool isHeader = false,
    bool isAmountField = false,
    bool isDetails = false}) {
  return pw.Padding(
    padding: pw.EdgeInsets.all(4),
    child: pw.Text(text,
        textAlign: isDetails
            ? pw.TextAlign.left
            : isAmountField
                ? pw.TextAlign.right
                : pw.TextAlign.center,
        style: pw.TextStyle(
            fontSize: 8,
            fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal)),
  );
}

// Helper function for Total Rows
pw.Widget _totalRow(String title, double value,
    {bool isBold = false, bool isNegative = false}) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Text(title,
          style: pw.TextStyle(
              fontSize: 8,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
      pw.Text(
          isNegative
              ? "₹ ${value.toStringAsFixed(2)}"
              : "₹ ${value.toStringAsFixed(2)}",
          style: pw.TextStyle(
              fontSize: 8,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
    ],
  );
}

// Fetch Image from Network URL
Future<Uint8List> fetchNetworkImage(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception("Failed to load image");
  }
}
