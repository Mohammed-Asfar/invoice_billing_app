import 'package:flutter/material.dart';
import 'package:invoice_billing_app/core/theme/app_colors.dart';

void showLoaderDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false, // Prevents closing by tapping outside
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                "Please wait...",
                style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    },
  );
}
