import 'package:flutter/material.dart';

class InvoiceDetailHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const InvoiceDetailHeader(
      {super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(
          width: 10,
        ),
        Text(title, style: TextStyle(fontSize: 13, color: Colors.white))
      ],
    );
  }
}
