import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// Function to generate an invoice matching the PDF format
Future<Uint8List> generateInvoicePdf1() async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Header Section
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('TBS ENTERPRISES',
                      style: pw.TextStyle(
                          fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  pw.Text('No: 22, MMS COMPLEX, PUDUPATTINAM'),
                  pw.Text('KALPAKKAM-603102'),
                  pw.Text('Mobile: 9655246269'),
                  pw.Text('GSTIN/UIN: 33AHOPY8219N1ZE'),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('Invoice No: 2024-1201',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Dated: 02-Dec-2024'),
                  pw.Text('Mode/Terms of Payment: Cash'),
                ],
              ),
            ],
          ),

          pw.SizedBox(height: 20),

          // Buyer Details
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Buyer:',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Name: The Head SISD,'),
                  pw.Text('Address: EIG/IGCAR, Kalpakam-603102'),
                  pw.Text('GSTIN/UIN: --'),
                  pw.Text('State Name: Tamil Nadu, Code: 33'),
                ],
              ),
              pw.Text('Terms of Delivery: --'),
            ],
          ),

          pw.SizedBox(height: 20),

          // Itemized List
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: pw.FlexColumnWidth(4),
              1: pw.FlexColumnWidth(1),
              2: pw.FlexColumnWidth(1),
              3: pw.FlexColumnWidth(2),
            },
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColor.fromHex("EFEFEF")),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('Description of Goods',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('Qty',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('Rate',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('Amount',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('Peek Adapter M-b to 10-32 Supelco - 55069'),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('1'),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('1,694.92'),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('1,694.92'),
                  ),
                ],
              ),
            ],
          ),

          pw.SizedBox(height: 20),

          // Footer
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Amount Chargeable (in Words):',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Two Thousand Rupees Only'),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('Sub-Total: 1,694.92'),
                  pw.Text('SGST @ 9%: 152.54'),
                  pw.Text('CGST @ 9%: 152.54'),
                  pw.Text('Rounded Off: 0.01'),
                  pw.Text('Total: 2,000.00',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ],
          ),

          pw.SizedBox(height: 20),

          pw.Text('Company Bank Details:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text('Name: M/S TBS ENTERPRISES'),
          pw.Text('Bank Name: Union Bank'),
          pw.Text('A/c No: 510101006884868'),
          pw.Text('Branch & IFSC: Kadalur Village & UBIN0935051'),

          pw.SizedBox(height: 20),

          pw.Text("Customer's Seal and Signature:"),
          pw.SizedBox(height: 20),
          pw.Text('For: TBS Enterprises',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text('Authorised Signatory'),
        ],
      ),
    ),
  );

  return pdf.save();
}
