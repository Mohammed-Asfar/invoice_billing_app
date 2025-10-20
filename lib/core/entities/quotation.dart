// ignore_for_file: public_member_api_docs, sort_constructors_first

class Quotation {
  final String quotationNumber;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String customerStateName;
  final String customerCode;
  final String shippingName;
  final String shippingAddress;
  final String shippingState;
  final String shippingCode;
  final DateTime issuedDate;
  final DateTime validUntilDate;
  final List<Product> products;
  final double subTotal;
  final double sgstPercent;
  final double cgstPercent;
  final double sgstAmount;
  final double cgstAmount;
  final double roundOff;
  final double grandTotal;
  final String grandTotalInWords;

  Quotation({
    required this.quotationNumber,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.customerStateName,
    required this.customerCode,
    required this.shippingName,
    required this.shippingAddress,
    required this.shippingState,
    required this.shippingCode,
    required this.issuedDate,
    required this.validUntilDate,
    required this.products,
    required this.subTotal,
    required this.sgstPercent,
    required this.cgstPercent,
    required this.sgstAmount,
    required this.cgstAmount,
    required this.roundOff,
    required this.grandTotal,
    required this.grandTotalInWords,
  });
}

class Product {
  final String description;
  final int quantity;
  final double rate;
  final double rateWithTax;
  final String per;
  final double totalPrice;

  Product({
    required this.description,
    required this.quantity,
    required this.rate,
    required this.rateWithTax,
    required this.per,
    required this.totalPrice,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': description,
      'quantity': quantity,
      'rate': rate,
      'rateWithTax': rateWithTax,
      'per': per,
      'totalPrice': totalPrice,
    };
  }

  static Product fromMap(Map<String, dynamic> map) {
    return Product(
      description: map['description'] as String,
      quantity: map['quantity'] as int,
      rate: map['rate'] as double,
      rateWithTax: map['rateWithTax'] as double,
      per: map['per'] as String,
      totalPrice: map['totalPrice'] as double,
    );
  }
}