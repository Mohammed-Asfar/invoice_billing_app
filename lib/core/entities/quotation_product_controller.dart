import 'package:flutter/material.dart';

class QuotationProductController {
  final TextEditingController description;
  final TextEditingController quantity;
  final TextEditingController rate;
  final TextEditingController rateWithTax;
  final TextEditingController per;
  final TextEditingController totalPrice;

  QuotationProductController(
      {required this.description,
      required this.quantity,
      required this.rate,
      required this.rateWithTax,
      required this.per,
      required this.totalPrice});
}