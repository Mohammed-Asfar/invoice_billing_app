import 'package:flutter/material.dart';

class Productcontroller {
  final TextEditingController description;
  final TextEditingController hsn;
  final TextEditingController quantity;
  final TextEditingController rate;
  final TextEditingController rateWithTax;
  final TextEditingController per;
  final TextEditingController totalPrice;

  Productcontroller(
      {required this.description,
      required this.hsn,
      required this.quantity,
      required this.rate,
      required this.rateWithTax,
      required this.per,
      required this.totalPrice});
}
