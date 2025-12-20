import 'package:flutter/material.dart';
import 'package:invoice_billing_app/core/models/quotation_model.dart';
import 'package:invoice_billing_app/core/entities/quotation.dart';
import 'package:invoice_billing_app/core/utils/number_to_word.dart';
import 'package:invoice_billing_app/core/entities/quotation_product_controller.dart';

class QuotationController {
  QuotationController();

  List<QuotationProductController> productControllers = [
    QuotationProductController(
      description: TextEditingController(),
      quantity: TextEditingController(),
      rate: TextEditingController(),
      rateWithTax: TextEditingController(),
      per: TextEditingController(),
      totalPrice: TextEditingController(),
    ),
  ];

  TextEditingController quotationNoController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerPhoneController = TextEditingController();
  TextEditingController customerAddressController = TextEditingController();
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
  TextEditingController termsAndConditionsController = TextEditingController();

  DateTime issuedDateController = DateTime.now();
  DateTime validUntilDateController = DateTime.now().add(Duration(days: 30));

  /// Factory constructor to create a QuotationController from an existing Quotation
  factory QuotationController.fromQuotation(Quotation quotation) {
    final controller = QuotationController();
    controller.quotationNoController.text = quotation.quotationNumber;
    controller.customerNameController.text = quotation.customerName;
    controller.customerPhoneController.text = quotation.customerPhone;
    controller.customerAddressController.text = quotation.customerAddress;
    controller.customerStateNameController.text = quotation.customerStateName;
    controller.customerCodeController.text = quotation.customerCode;
    controller.shippingNameController.text = quotation.shippingName;
    controller.shippingAddressController.text = quotation.shippingAddress;
    controller.shippingStateController.text = quotation.shippingState;
    controller.shippingCodeController.text = quotation.shippingCode;
    controller.issuedDateController = quotation.issuedDate;
    controller.validUntilDateController = quotation.validUntilDate;
    controller.subTotalController.text = quotation.subTotal.toStringAsFixed(2);
    controller.sgsttaxController.text =
        quotation.sgstPercent.toStringAsFixed(0);
    controller.cgsttaxController.text =
        quotation.cgstPercent.toStringAsFixed(0);
    controller.sgstController.text = quotation.sgstAmount.toStringAsFixed(2);
    controller.cgstController.text = quotation.cgstAmount.toStringAsFixed(2);
    controller.roundOffController.text = quotation.roundOff.toStringAsFixed(2);
    controller.grandTotalController.text =
        quotation.grandTotal.toStringAsFixed(2);
    controller.grandTotalInWordsController.text = quotation.grandTotalInWords;
    controller.termsAndConditionsController.text = quotation.termsAndConditions;

    // Populate product controllers
    controller.productControllers.clear();
    for (var product in quotation.products) {
      controller.productControllers.add(
        QuotationProductController(
          description: TextEditingController(text: product.description),
          quantity: TextEditingController(text: product.quantity.toString()),
          rate: TextEditingController(text: product.rate.toString()),
          rateWithTax:
              TextEditingController(text: product.rateWithTax.toString()),
          per: TextEditingController(text: product.per),
          totalPrice:
              TextEditingController(text: product.totalPrice.toString()),
        ),
      );
    }

    return controller;
  }

  void addProductController() {
    productControllers.add(
      QuotationProductController(
        description: TextEditingController(),
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
      roundOffController.text = roundOff.toStringAsFixed(2);
      grandTotalController.text = grandTotal.toStringAsFixed(2);
      grandTotalInWordsController.text = numberToWords(grandTotal.toInt());
    });
  }

  QuotationModel toQuotationModel() {
    return QuotationModel(
      quotationNumber: quotationNoController.text.trim(),
      customerName: customerNameController.text.trim(),
      customerPhone: customerPhoneController.text.trim(),
      customerAddress: customerAddressController.text.trim(),
      customerStateName: customerStateNameController.text.trim(),
      customerCode: customerCodeController.text.trim(),
      shippingName: shippingNameController.text.trim(),
      shippingAddress: shippingAddressController.text.trim(),
      shippingState: shippingStateController.text.trim(),
      shippingCode: shippingCodeController.text.trim(),
      issuedDate: issuedDateController,
      validUntilDate: validUntilDateController,
      products: productControllers.map((productController) {
        return Product(
          description: productController.description.text.trim(),
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
      termsAndConditions: termsAndConditionsController.text.trim(),
    );
  }
}
