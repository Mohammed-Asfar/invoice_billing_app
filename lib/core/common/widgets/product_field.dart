import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invoice_billing_app/core/theme/app_colors.dart';
import 'package:invoice_billing_app/core/theme/app_theme.dart';
import 'package:invoice_billing_app/core/utils/show_snackbar.dart';

class ProductField extends StatelessWidget {
  final TextEditingController controller;
  final IconData? icon;
  final String hintText;
  final bool obscureText;
  final bool readOnly;
  final bool isNumerical;
  final void Function(String)? onChange;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final Widget? prefixWidget;
  final void Function()? onSubmit;

  const ProductField({
    super.key,
    required this.controller,
    this.icon,
    required this.hintText,
    this.isNumerical = false,
    this.readOnly = false,
    this.onChange,
    this.obscureText = false,
    this.focusNode,
    this.nextFocusNode,
    this.prefixWidget,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      ),
      child: TextFormField(
        cursorErrorColor: AppColors.primaryColor,
        focusNode: focusNode,
        inputFormatters: isNumerical
            ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))]
            : null,
        onChanged: onChange,
        readOnly: readOnly,
        cursorColor: AppColors.primaryColor,
        style: TextStyle(
          color: AppColors.primaryColor,
          fontSize: 12,
        ),
        controller: controller,
        obscureText: obscureText,
        validator: (value) {
          if (value!.isEmpty || value == "") {
            showSnackBar(context: context, text: "$hintText is missing!");
            return "";
          }
          return null;
        },
        onFieldSubmitted: (value) {
          if (onSubmit != null) {
            onSubmit!();
          }
          if (nextFocusNode != null) {
            // Move focus to the next field
            FocusScope.of(context).requestFocus(nextFocusNode);
          }
        },
        decoration: InputDecoration(
          errorStyle: TextStyle(height: 0.00000001),
          hintText: hintText,
          hintStyle: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.grey,
            fontSize: 11,
          ),
          prefixIcon: prefixWidget ??
              (icon == null
                  ? null
                  : Icon(
                      icon,
                      color: AppColors.primaryColor,
                      size: 16,
                    )),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
