// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:invoice_billing_app/core/entities/invoice.dart';
import 'package:invoice_billing_app/core/models/product_model.dart';

class InvoiceModel extends Invoice {
  InvoiceModel({
    required super.invoiceNumber,
    required super.customerName,
    required super.customerPhone,
    required super.customerAddress,
    required super.customerGSTIN,
    required super.issuedDate,
    required super.products,
    required super.subTotal,
    required super.sgstPercent,
    required super.cgstPercent,
    required super.sgstAmount,
    required super.cgstAmount,
    required super.roundOff,
    required super.grandTotal,
    required super.grandTotalInWords,
    required super.customerStateName,
    required super.customerCode,
    required super.shippingName,
    required super.shippingAddress,
    required super.shippingState,
    required super.shippingCode,
  });

  InvoiceModel copyWith({
    String? invoiceNumber,
    String? customerName,
    String? customerPhone,
    String? customerAddress,
    String? customerGSTIN,
    DateTime? issuedDate,
    List<ProductModel>? products,
    double? subTotal,
    double? sgstPercent,
    double? cgstPercent,
    double? sgstAmount,
    double? cgstAmount,
    double? roundOff,
    double? grandTotal,
    String? grandTotalInWords,
    String? customerStateName,
    String? customerCode,
    String? shippingName,
    String? shippingAddress,
    String? shippingState,
    String? shippingCode,
  }) {
    return InvoiceModel(
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerAddress: customerAddress ?? this.customerAddress,
      customerGSTIN: customerGSTIN ?? this.customerGSTIN,
      issuedDate: issuedDate ?? this.issuedDate,
      products: products ?? this.products,
      subTotal: subTotal ?? this.subTotal,
      sgstPercent: sgstPercent ?? this.sgstPercent,
      cgstPercent: cgstPercent ?? this.cgstPercent,
      sgstAmount: sgstAmount ?? this.sgstAmount,
      cgstAmount: cgstAmount ?? this.cgstAmount,
      roundOff: roundOff ?? this.roundOff,
      grandTotal: grandTotal ?? this.grandTotal,
      grandTotalInWords: grandTotalInWords ?? this.grandTotalInWords,
      customerStateName: customerStateName ?? this.customerStateName,
      customerCode: customerCode ?? this.customerCode,
      shippingName: shippingName ?? this.shippingName,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      shippingState: shippingState ?? this.shippingState,
      shippingCode: shippingCode ?? this.shippingCode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'invoiceNumber': invoiceNumber,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'customerGSTIN': customerGSTIN,
      'issuedDate': issuedDate.millisecondsSinceEpoch,
      'products':
          (products as List<ProductModel>).map((x) => x.toMap()).toList(),
      'subTotal': subTotal,
      'sgstPercent': sgstPercent,
      'cgstPercent': cgstPercent,
      'sgstAmount': sgstAmount,
      'cgstAmount': cgstAmount,
      'roundOff': roundOff,
      'grandTotal': grandTotal,
      'grandTotalInWords': grandTotalInWords,
      'customerStateName': customerStateName,
      'customerCode': customerCode,
      'shippingName': shippingName,
      'shippingAddress': shippingAddress,
      'shippingState': shippingState,
      'shippingCode': shippingCode,
    };
  }

  factory InvoiceModel.fromEntity(Invoice invoice) {
    return InvoiceModel(
      invoiceNumber: invoice.invoiceNumber,
      customerName: invoice.customerName,
      customerPhone: invoice.customerPhone,
      customerAddress: invoice.customerAddress,
      customerGSTIN: invoice.customerGSTIN,
      issuedDate: invoice.issuedDate,
      products: invoice.products
          .map((product) => ProductModel.fromEntity(product))
          .toList(),
      subTotal: invoice.subTotal,
      sgstPercent: invoice.sgstPercent,
      cgstPercent: invoice.cgstPercent,
      sgstAmount: invoice.sgstAmount,
      cgstAmount: invoice.cgstAmount,
      roundOff: invoice.roundOff,
      grandTotal: invoice.grandTotal,
      grandTotalInWords: invoice.grandTotalInWords,
      customerStateName: invoice.customerStateName,
      customerCode: invoice.customerCode,
      shippingName: invoice.shippingName,
      shippingAddress: invoice.shippingAddress,
      shippingState: invoice.shippingState,
      shippingCode: invoice.shippingCode,
    );
  }

  factory InvoiceModel.fromMap(Map<String, dynamic> map) {
    return InvoiceModel(
      invoiceNumber: map['invoiceNumber'] as String,
      customerName: map['customerName'] as String,
      customerPhone: map['customerPhone'] as String,
      customerAddress: map['customerAddress'] as String,
      customerGSTIN: map['customerGSTIN'] as String,
      issuedDate: DateTime.fromMillisecondsSinceEpoch(
          (map['issuedDate'] as num).toInt()),
      products: List<ProductModel>.from(
        (map['products'] as List).map<ProductModel>(
          (x) => ProductModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      subTotal: map['subTotal'] as double,
      sgstPercent: map['sgstPercent'] as double,
      cgstPercent: map['cgstPercent'] as double,
      sgstAmount: map['sgstAmount'] as double,
      cgstAmount: map['cgstAmount'] as double,
      roundOff: map['roundOff'] as double,
      grandTotal: map['grandTotal'] as double,
      grandTotalInWords: map['grandTotalInWords'] as String,
      customerStateName: map['customerStateName'] as String,
      customerCode: map['customerCode'] as String,
      shippingName: map['shippingName'] as String,
      shippingAddress: map['shippingAddress'] as String,
      shippingState: map['shippingState'] as String,
      shippingCode: map['shippingCode'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory InvoiceModel.fromJson(String source) =>
      InvoiceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'InvoiceModel(invoiceNumber: $invoiceNumber, customerName: $customerName, customerPhone: $customerPhone, customerAddress: $customerAddress, customerGSTIN: $customerGSTIN, issuedDate: $issuedDate, products: $products, subTotal: $subTotal, sgstPercent: $sgstPercent, cgstPercent: $cgstPercent, sgstAmount: $sgstAmount, cgstAmount: $cgstAmount, roundOff: $roundOff, grandTotal: $grandTotal, grandTotalInWords: $grandTotalInWords, customerStateName: $customerStateName, customerCode: $customerCode, shippingName: $shippingName, shippingAddress: $shippingAddress, shippingState: $shippingState, shippingCode: $shippingCode)';
  }

  @override
  bool operator ==(covariant InvoiceModel other) {
    if (identical(this, other)) return true;

    return other.invoiceNumber == invoiceNumber &&
        other.customerName == customerName &&
        other.customerPhone == customerPhone &&
        other.customerAddress == customerAddress &&
        other.customerGSTIN == customerGSTIN &&
        other.issuedDate == issuedDate &&
        listEquals(other.products, products) &&
        other.subTotal == subTotal &&
        other.sgstPercent == sgstPercent &&
        other.cgstPercent == cgstPercent &&
        other.sgstAmount == sgstAmount &&
        other.cgstAmount == cgstAmount &&
        other.roundOff == roundOff &&
        other.grandTotal == grandTotal &&
        other.grandTotalInWords == grandTotalInWords &&
        other.customerStateName == customerStateName &&
        other.customerCode == customerCode &&
        other.shippingName == shippingName &&
        other.shippingAddress == shippingAddress &&
        other.shippingState == shippingState &&
        other.shippingCode == shippingCode;
  }

  @override
  int get hashCode {
    return invoiceNumber.hashCode ^
        customerName.hashCode ^
        customerPhone.hashCode ^
        customerAddress.hashCode ^
        customerGSTIN.hashCode ^
        issuedDate.hashCode ^
        products.hashCode ^
        subTotal.hashCode ^
        sgstPercent.hashCode ^
        cgstPercent.hashCode ^
        sgstAmount.hashCode ^
        cgstAmount.hashCode ^
        roundOff.hashCode ^
        grandTotal.hashCode ^
        grandTotalInWords.hashCode ^
        customerStateName.hashCode ^
        customerCode.hashCode ^
        shippingName.hashCode ^
        shippingAddress.hashCode ^
        shippingState.hashCode ^
        shippingCode.hashCode;
  }
}
