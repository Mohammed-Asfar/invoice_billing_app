import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:invoice_billing_app/core/entities/quotation.dart';
import 'package:invoice_billing_app/core/entities/user.dart';
import 'package:invoice_billing_app/core/utils/date_format.dart';

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
              ? "- ₹ ${value.abs().toStringAsFixed(2)}"
              : "₹ ${value.toStringAsFixed(2)}",
          style: pw.TextStyle(
              fontSize: 8,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
    ],
  );
}

Future<Uint8List> fetchNetworkImage(String url) async {
  final response = await http.get(Uri.parse(url));
  return response.bodyBytes;
}

Future<Uint8List> generateQuotationPDF(
    {required User user, required Quotation quotation}) async {
  // Load fonts
  final fontRegular =
      pw.Font.ttf(await rootBundle.load("assets/fonts/Poppins-Regular.ttf"));
  final fontBold =
      pw.Font.ttf(await rootBundle.load("assets/fonts/Poppins-Bold.ttf"));

  // Create PDF document
  final pdf = pw.Document(
    theme: pw.ThemeData.withFont(
      base: fontRegular,
      bold: fontBold,
    ),
  );

  int countNum = 0;
  // Fetch company logo
  final Uint8List logoData = await fetchNetworkImage(user.companyLogo);
  final pw.ImageProvider logo = pw.MemoryImage(logoData);

  // Add a page to the PDF
  pdf.addPage(
    pw.Page(
      margin: pw.EdgeInsets.only(top: 20, left: 35, right: 35, bottom: 30),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Spacer(),
                pw.SizedBox(width: 100),
                pw.Text(
                  "QUOTATION",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Spacer(),
                pw.Text(
                  "(ORIGINAL FOR RECIPIENT)",
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(fontSize: 8),
                ),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Image(
                  logo,
                  width: 100,
                  height: 80,
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(user.companyName,
                        style: pw.TextStyle(
                            fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    pw.Text(user.companyAddress,
                        style: pw.TextStyle(fontSize: 10)),
                    pw.Text("Mobile: ${user.mobileNumber}",
                        style: pw.TextStyle(fontSize: 10)),
                    pw.Text("GSTIN/UIN: ${user.companyGSTIN}",
                        style: pw.TextStyle(fontSize: 10)),
                    pw.Text("State: ${user.stateName}, Code: ${user.code}",
                        style: pw.TextStyle(fontSize: 10)),
                    pw.Text("Email: ${user.email}",
                        style: pw.TextStyle(fontSize: 10)),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 5),
            pw.Divider(),

            // Quotation Details
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Quotation No: ${quotation.quotationNumber}",
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 12)),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text("Date: ${dateFormat(quotation.issuedDate)}",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 12)),
                    pw.Text("Valid Until: ${dateFormat(quotation.validUntilDate)}",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 5),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.SizedBox(
                  width: 200,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Billed To:",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 12)),
                      _infoTable([
                        ["Name:", quotation.customerName],
                        [
                          "Address:",
                          quotation.customerAddress.split("\$").join("\n")
                        ],
                        ["Mobile:", quotation.customerPhone],
                        [
                          "State:",
                          "${quotation.customerStateName}, Code: ${quotation.customerCode}"
                        ],
                      ]),
                    ],
                  ),
                ),
                pw.Spacer(),
                pw.SizedBox(width: 20),
                quotation.shippingName == ""
                    ? pw.Container()
                    : pw.SizedBox(
                        width: 200,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("Shipped To:",
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 12)),
                            _infoTable([
                              ["Name:", quotation.shippingName],
                              [
                                "Address:",
                                quotation.shippingAddress.split("\$").join("\n")
                              ],
                              [
                                "State:",
                                "${quotation.shippingState}, Code: ${quotation.shippingCode}"
                              ],
                            ]),
                          ],
                        ),
                      ),
              ],
            ),
            pw.SizedBox(height: 5),
            pw.Divider(),

            // Product Table
            pw.Table(
              border: pw.TableBorder.all(width: 0.5, color: PdfColors.black),
              columnWidths: {
                0: pw.FixedColumnWidth(30),
                1: pw.FlexColumnWidth(4),
                2: pw.FixedColumnWidth(40),
                3: pw.FixedColumnWidth(40),
                4: pw.FlexColumnWidth(1),
                5: pw.FlexColumnWidth(1),
              },
              children: [
                // Table Header
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    _tableCell("S.No", isHeader: true),
                    _tableCell("Description", isHeader: true),
                    _tableCell("Qty", isHeader: true),
                    _tableCell("Rate", isHeader: true),
                    _tableCell("Unit", isHeader: true),
                    _tableCell("Amount", isHeader: true),
                  ],
                ),
                // Dynamically Populate Product Data
                ...quotation.products.map((product) {
                  countNum += 1;
                  final double amount = product.rate * product.quantity;

                  return pw.TableRow(
                    children: [
                      _tableCell(countNum.toString()),
                      _tableCell(product.description, isDetails: true),
                      _tableCell(product.quantity.toString()),
                      _tableCell(product.rate.toStringAsFixed(2)),
                      _tableCell(product.per),
                      _tableCell(amount.toStringAsFixed(2),
                          isAmountField: true),
                    ],
                  );
                }),
              ],
            ),
            pw.SizedBox(height: 5),

            // Quotation Totals
            _totalRow("Sub-Total:", quotation.subTotal),
            quotation.customerCode == "33"
                ? pw.Container()
                : _totalRow(
                    "OUTPUT IGST @ ${quotation.cgstPercent + quotation.sgstPercent}%:",
                    quotation.cgstAmount + quotation.sgstAmount),
            quotation.customerCode != "33"
                ? pw.Container()
                : _totalRow("OUTPUT CGST @ ${quotation.cgstPercent}%:",
                    quotation.cgstAmount),
            quotation.customerCode != "33"
                ? pw.Container()
                : _totalRow("OUTPUT SGST @ ${quotation.sgstPercent}%:",
                    quotation.sgstAmount),

            _totalRow("Round Off: ", quotation.roundOff, isNegative: true),
            pw.Text(
                "Total GST Amount(${quotation.cgstPercent + quotation.sgstPercent}%):  ₹ ${quotation.cgstAmount + quotation.sgstAmount}",
                style: pw.TextStyle(fontSize: 8)),

            pw.Divider(),

            _totalRow("Total:", quotation.grandTotal, isBold: true),
            pw.Text("Total in Words: ${quotation.grandTotalInWords}",
                style: pw.TextStyle(fontSize: 8)),

            pw.SizedBox(height: 20),
            pw.Text("This quotation is valid until ${dateFormat(quotation.validUntilDate)}.",
                style: pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 10),

            pw.Spacer(),
            pw.SizedBox(height: 50),
            // Signatory Section
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Customer's Seal & Signature",
                    style: pw.TextStyle(fontSize: 10)),
                pw.Text("For Authorised Signatory",
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 10)),
              ],
            ),
          ],
        );
      },
    ),
  );

  // Save and return the PDF as bytes
  return await pdf.save();
}

pw.Widget _infoTable(List<List<String>> data) {
  final textStyle = pw.TextStyle(fontSize: 10);
  return pw.Table(
    columnWidths: {
      0: pw.FixedColumnWidth(50),
      1: pw.FlexColumnWidth(),
    },
    children: data.map((row) {
      return pw.TableRow(
        children: [
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 2),
            child: pw.Text(row[0], style: textStyle),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 2),
            child: pw.Text(row[1], style: textStyle),
          ),
        ],
      );
    }).toList(),
  );
}