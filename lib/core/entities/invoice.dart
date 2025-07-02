// ignore_for_file: public_member_api_docs, sort_constructors_first

class Invoice {
  final String invoiceNumber;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String customerGSTIN;
  final String customerStateName;
  final String customerCode;
  final String shippingName;
  final String shippingAddress;
  final String shippingState;
  final String shippingCode;
  final DateTime issuedDate;
  final List<Product> products;
  final double subTotal;
  final double sgstPercent;
  final double cgstPercent;
  final double sgstAmount;
  final double cgstAmount;
  final double roundOff;
  final double grandTotal;
  final String grandTotalInWords;

  Invoice({
    required this.invoiceNumber,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.customerGSTIN,
    required this.customerStateName,
    required this.customerCode,
    required this.shippingName,
    required this.shippingAddress,
    required this.shippingState,
    required this.shippingCode,
    required this.issuedDate,
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
  final String hsn;
  final int quantity;
  final double rate;
  final double rateWithTax;
  final String per;
  final double totalPrice;

  Product({
    required this.description,
    required this.hsn,
    required this.quantity,
    required this.rate,
    required this.rateWithTax,
    required this.per,
    required this.totalPrice,
  });
}
