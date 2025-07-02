import 'package:flutter/material.dart';
import 'package:invoice_billing_app/core/theme/app_colors.dart';
import 'package:invoice_billing_app/core/theme/app_theme.dart';

class BasicButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final Color? color;
  const BasicButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = AppColors.secondaryColor,
    this.width = double.maxFinite,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(AppColors.selectedFontColor),
          backgroundColor: WidgetStatePropertyAll(color),
          fixedSize: WidgetStatePropertyAll(Size(width, 45)),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius)))),
      child: Text(
        text,
      ),
    );
  }
}
