import 'package:flutter/material.dart';
import 'package:invoice_billing_app/core/theme/app_colors.dart';
import 'package:invoice_billing_app/core/theme/app_theme.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  const AuthButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.width = double.maxFinite});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(AppColors.selectedFontColor),
          backgroundColor: WidgetStatePropertyAll(AppColors.secondaryColor),
          fixedSize: WidgetStatePropertyAll(Size(width, 45)),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius)))),
      child: Text(
        text,
      ),
    );
  }
}
