// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:invoice_billing_app/core/theme/app_colors.dart';
import 'package:invoice_billing_app/core/theme/app_theme.dart';

class DateField extends StatelessWidget {
  final String date;
  final String hintText;

  final VoidCallback onTap;
  const DateField({
    super.key,
    required this.date,
    required this.hintText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(hintText),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.date_range_rounded,
                  color: AppColors.primaryColor,
                ),
                title: Text(
                  date,
                  style: TextStyle(color: AppColors.primaryColor, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
