import 'package:flutter/material.dart';
import 'package:invoice_billing_app/core/models/invoice_model.dart';
import 'package:invoice_billing_app/core/models/product_model.dart';
import 'package:invoice_billing_app/core/utils/number_to_word.dart';
import 'package:invoice_billing_app/core/entities/productController.dart';

class InvoiceController {
  List<Productcontroller> productControllers = [
    Productcontroller(
      description: TextEditingController(),
      hsn: TextEditingController(),
      quantity: TextEditingController(),
      rate: TextEditingController(),
      rateWithTax: TextEditingController(),
      per: TextEditingController(),
      totalPrice: TextEditingController(),
    ),
  ];

  TextEditingController invoiceNoController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerPhoneController = TextEditingController();
  TextEditingController customerAddressController = TextEditingController();
  TextEditingController customerGSTINController = TextEditingController();
  TextEditingController customerStateNameController = TextEditingController();
  TextEditingController customerCodeController = TextEditingController();
  TextEditingController shippingNameController = TextEditingController();
  TextEditingController shippingAddressController = TextEditingController();
  TextEditingController shippingStateController = TextEditingController();
  TextEditingController shippingCodeController = TextEditingController();
  TextEditingController subTotalController = TextEditingController();
  TextEditingController sgstController = TextEditingController();
  TextEditingController cgstController = TextEditingController();
  TextEditingController roundOffController = TextEditingController();
  TextEditingController sgsttaxController = TextEditingController(text: "9");
  TextEditingController cgsttaxController = TextEditingController(text: "9");
  TextEditingController roundoffController = TextEditingController();
  TextEditingController grandTotalController = TextEditingController();
  TextEditingController grandTotalInWordsController = TextEditingController();
  TextEditingController igstTaxController = TextEditingController(text: "18");
  TextEditingController igstAmountController = TextEditingController();
  bool isIgst = false;

  DateTime issuedDateController = DateTime.now();

  void addProductController() {
    productControllers.add(
      Productcontroller(
        description: TextEditingController(),
        hsn: TextEditingController(),
        quantity: TextEditingController(),
        rate: TextEditingController(),
        rateWithTax: TextEditingController(),
        per: TextEditingController(),
        totalPrice: TextEditingController(),
      ),
    );
  }

  void removeProductController({required int index}) {
    productControllers.removeAt(index);
  }

  void calculateWithTax(int index) {
    double sgstPercent = double.tryParse(sgsttaxController.text) ?? 0.0;
    double cgstPercent = double.tryParse(cgsttaxController.text) ?? 0.0;
    double rate = double.tryParse(productControllers[index].rate.text) ?? 0.0;
    double rateWithTax =
        double.tryParse(productControllers[index].rateWithTax.text) ?? 0.0;

    // Calculate rateWithTax if rate (without tax) is provided
    if (rate > 0.0) {
      rateWithTax = rate + (rate * (sgstPercent + cgstPercent) / 100);
      productControllers[index].rateWithTax.text = rateWithTax.toString();
    }
  }

  void calculateWithoutTax(int index) {
    double sgstPercent = double.tryParse(sgsttaxController.text) ?? 0.0;
    double cgstPercent = double.tryParse(cgsttaxController.text) ?? 0.0;
    double rate = double.tryParse(productControllers[index].rate.text) ?? 0.0;
    double rateWithTax =
        double.tryParse(productControllers[index].rateWithTax.text) ?? 0.0;

    if (rateWithTax > 0.0) {
      double gstAmount = rateWithTax -
          (rateWithTax / (1 + ((sgstPercent + cgstPercent) / 100.0)));
      rate = rateWithTax - gstAmount;
      productControllers[index].rate.text = rate.toString();
    }
  }

  void syncIgstToSgstCgst() {
    double igstPercent = double.tryParse(igstTaxController.text) ?? 0.0;
    sgsttaxController.text = (igstPercent / 2).toString();
    cgsttaxController.text = (igstPercent / 2).toString();
  }

  void calculateTotals() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double subTotal = 0.0;
      double sgstPercent = double.tryParse(sgsttaxController.text) ?? 0.0;
      double cgstPercent = double.tryParse(cgsttaxController.text) ?? 0.0;

      for (var product in productControllers) {
        double quantity = double.tryParse(product.quantity.text) ?? 0.0;
        double rateTax = double.tryParse(product.rateWithTax.text) ?? 0.0;
        double rate = double.tryParse(product.rate.text) ?? 0.0;
        double totalWithTax = quantity * rateTax;
        double totalWithoutTax = quantity * rate;

        // Update total price for each product
        product.totalPrice.text = totalWithTax.toString();

        // Add to subtotal
        subTotal += totalWithoutTax;
      }

      // Calculate SGST and CGST amounts
      double sgst = (subTotal * sgstPercent) / 100;
      double cgst = (subTotal * cgstPercent) / 100;

      // Calculate round-off and grand total
      double rawTotal = subTotal + sgst + cgst;
      double roundOff = rawTotal.roundToDouble() - rawTotal;
      double grandTotal = rawTotal + roundOff;

      // Update controllers
      subTotalController.text = subTotal.toStringAsFixed(2);
      sgstController.text = sgst.toStringAsFixed(2);
      cgstController.text = cgst.toStringAsFixed(2);
      igstAmountController.text = (sgst + cgst).toStringAsFixed(2);
      roundOffController.text = roundOff.toStringAsFixed(2);
      grandTotalController.text = grandTotal.toStringAsFixed(2);
      grandTotalInWordsController.text = numberToWords(grandTotal.toInt());
    });
  }

  InvoiceModel toInvoiceModel() {
    return InvoiceModel(
      invoiceNumber: invoiceNoController.text.trim(),
      customerName: customerNameController.text.trim(),
      customerPhone: customerPhoneController.text.trim(),
      customerAddress: customerAddressController.text.trim(),
      customerGSTIN: customerGSTINController.text.trim(),
      issuedDate: issuedDateController,
      products: productControllers.map((productController) {
        return ProductModel(
          description: productController.description.text.trim(),
          hsn: productController.hsn.text.trim(),
          quantity: int.tryParse(productController.quantity.text) ?? 0,
          rate: double.tryParse(productController.rate.text) ?? 0.0,
          rateWithTax:
              double.tryParse(productController.rateWithTax.text) ?? 0.0,
          per: productController.per.text.trim(),
          totalPrice: double.tryParse(productController.totalPrice.text) ?? 0.0,
        );
      }).toList(),
      subTotal: double.tryParse(subTotalController.text) ?? 0.0,
      sgstPercent: double.tryParse(sgsttaxController.text) ?? 0.0,
      cgstPercent: double.tryParse(cgsttaxController.text) ?? 0.0,
      sgstAmount: double.tryParse(sgstController.text) ?? 0.0,
      cgstAmount: double.tryParse(cgstController.text) ?? 0.0,
      roundOff: double.tryParse(roundOffController.text) ?? 0.0,
      grandTotal: double.tryParse(grandTotalController.text) ?? 0.0,
      grandTotalInWords: grandTotalInWordsController.text.trim(),
      customerStateName: customerStateNameController.text.trim(),
      customerCode: customerCodeController.text.trim(),
      shippingName: shippingNameController.text.trim(),
      shippingAddress: shippingAddressController.text.trim(),
      shippingState: shippingStateController.text.trim(),
      shippingCode: shippingCodeController.text.trim(),
      isIgst: isIgst,
    );
  }
}
