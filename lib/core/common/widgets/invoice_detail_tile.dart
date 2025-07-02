import 'package:flutter/material.dart';
import 'package:invoice_billing_app/core/theme/app_colors.dart';

class InvoiceDetailTile extends StatelessWidget {
  final String title;
  final String value;
  final MainAxisAlignment mainAxisAlignment;

  const InvoiceDetailTile(
      {super.key,
      required this.title,
      required this.value,
      this.mainAxisAlignment = MainAxisAlignment.start});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        SizedBox(
          width: 100,
          child: Text(title,
              style: TextStyle(
                  fontSize: 13,
                  color: AppColors.fontColor.withValues(alpha: 0.8))),
        ),
        Text(value,
            style: TextStyle(fontSize: 13, color: AppColors.selectedFontColor)),
      ],
    );
  }
}
