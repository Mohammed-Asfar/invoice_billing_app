import 'package:flutter/material.dart';
import 'package:invoice_billing_app/core/theme/app_colors.dart';
import 'package:invoice_billing_app/core/theme/app_theme.dart';
import 'package:invoice_billing_app/core/utils/show_snackbar.dart';

class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final IconData? icon;
  final String hintText;
  final bool obscureText;
  const AuthField({
    super.key,
    this.icon,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 6,
            spreadRadius: 3,
          ),
        ],
      ),
      child: TextFormField(
        cursorColor: AppColors.primaryColor,
        cursorErrorColor: AppColors.primaryColor,
        style: TextStyle(color: AppColors.primaryColor),
        controller: controller,
        obscureText: obscureText,
        validator: (value) {
          if (value!.isEmpty || value == "") {
            showSnackBar(context: context, text: "$hintText is missing!");
            return "";
          }
          return null;
        },
        decoration: InputDecoration(
          errorStyle: TextStyle(height: 0.00000001),
          hintText: hintText,
          hintStyle: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.grey,
            fontSize: 14,
          ),
          contentPadding: EdgeInsets.all(15),
          prefixIcon: icon == null
              ? null
              : Icon(
                  icon,
                  color: AppColors.primaryColor,
                ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
