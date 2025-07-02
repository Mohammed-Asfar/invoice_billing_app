part of 'invoice_templates.dart';

Future<Uint8List> generatefinalClassicInvoicePDF(
    {required User user, required Invoice invoice}) async {
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
                  "TAX INVOICE",
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

            // Invoice Details
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Invoice No: ${invoice.invoiceNumber}",
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 12)),
                pw.Text("Date: ${dateFormat(invoice.issuedDate)}",
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 12)),
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
                        ["Name:", invoice.customerName],
                        [
                          "Address:",
                          invoice.customerAddress.split("\$").join("\n")
                        ],
                        ["Mobile:", invoice.customerPhone],
                        [
                          "State:",
                          "${invoice.customerStateName}, Code: ${invoice.customerCode}"
                        ],
                        ["GSTIN:", invoice.customerGSTIN],
                      ]),
                    ],
                  ),
                ),
                pw.Spacer(),
                pw.SizedBox(width: 20),
                invoice.shippingName == ""
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
                              ["Name:", invoice.shippingName],
                              [
                                "Address:",
                                invoice.shippingAddress.split("\$").join("\n")
                              ],
                              [
                                "State:",
                                "${invoice.shippingState}, Code: ${invoice.shippingCode}"
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
                2: pw.FlexColumnWidth(1),
                3: pw.FixedColumnWidth(40),
                4: pw.FixedColumnWidth(40),
                5: pw.FlexColumnWidth(1),
                6: pw.FlexColumnWidth(1),
              },
              children: [
                // Table Header
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    _tableCell("S.No", isHeader: true),
                    _tableCell("Description", isHeader: true),
                    _tableCell("HSN/SAC", isHeader: true),
                    _tableCell("Qty", isHeader: true),
                    _tableCell("Unit", isHeader: true),
                    _tableCell("Rate", isHeader: true),
                    _tableCell("Amount", isHeader: true),
                  ],
                ),
                // Dynamically Populate Product Data
                ...invoice.products.map((product) {
                  countNum += 1;
                  final double amount = product.rate * product.quantity;

                  return pw.TableRow(
                    children: [
                      _tableCell(countNum.toString()),
                      _tableCell(product.description, isDetails: true),
                      _tableCell(product.hsn),
                      _tableCell(product.quantity.toString()),
                      _tableCell(product.per),
                      _tableCell(product.rate.toStringAsFixed(2)),
                      _tableCell(amount.toStringAsFixed(2),
                          isAmountField: true),
                    ],
                  );
                }),
              ],
            ),
            pw.SizedBox(height: 5),

            // Invoice Totals
            _totalRow("Sub-Total:", invoice.subTotal),
            invoice.customerCode == "33"
                ? pw.Container()
                : _totalRow(
                    "OUTPUT IGST @ ${invoice.cgstPercent.toInt() + invoice.sgstPercent.toInt()}%:",
                    invoice.cgstAmount + invoice.sgstAmount),
            invoice.customerCode != "33"
                ? pw.Container()
                : _totalRow("OUTPUT CGST @ ${invoice.cgstPercent.toInt()}%:",
                    invoice.cgstAmount),
            invoice.customerCode != "33"
                ? pw.Container()
                : _totalRow("OUTPUT SGST @ ${invoice.sgstPercent.toInt()}%:",
                    invoice.sgstAmount),

            _totalRow("Round Off: ", invoice.roundOff, isNegative: true),
            pw.Text(
                "Total GST Amount(${invoice.cgstPercent.toInt() + invoice.sgstPercent.toInt()}%):  ₹ ${invoice.cgstAmount + invoice.sgstAmount}",
                style: pw.TextStyle(fontSize: 8)),

            pw.Divider(),

            _totalRow("Total:", invoice.grandTotal, isBold: true),
            pw.Text("Total in Words: ${invoice.grandTotalInWords}",
                style: pw.TextStyle(fontSize: 8)),

            pw.SizedBox(height: 8),
            pw.Text("Company Bank Details:",
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
            pw.Text("Name: M/S TBS ENTERPRISES",
                style: pw.TextStyle(fontSize: 8)),
            pw.Text("A/c No: ${user.companyAccountNumber}",
                style: pw.TextStyle(fontSize: 8)),
            pw.Text("IFSC: ${user.accountIFSC}",
                style: pw.TextStyle(fontSize: 8)),
            pw.Text("Bank: ${user.bankName}, Branch: ${user.bankBranch}",
                style: pw.TextStyle(fontSize: 8)),
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
