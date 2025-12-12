import 'package:flutter/material.dart';
import 'package:invoice_billing_app/core/theme/app_colors.dart';
import 'package:invoice_billing_app/core/theme/app_theme.dart';
import 'package:invoice_billing_app/core/utils/show_snackbar.dart';

class BasicTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData? icon;
  final String hintText;
  final bool obscureText;
  final bool readOnly;
  final bool islabelNeeded;
  final int maxLines;
  const BasicTextField({
    super.key,
    this.icon,
    required this.controller,
    required this.hintText,
    this.islabelNeeded = true,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return islabelNeeded
        ? Container(
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
                  child: TextFormField(
                    readOnly: readOnly,
                    maxLines: maxLines,
                    cursorColor: AppColors.primaryColor,
                    cursorErrorColor: AppColors.primaryColor,
                    style: TextStyle(color: AppColors.primaryColor),
                    controller: controller,
                    obscureText: obscureText,
                    validator: (value) {
                      if (value!.isEmpty || value == "") {
                        showSnackBar(
                            context: context, text: "$hintText is missing!");
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
                        fontSize: 13,
                      ),
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
                ),
              ],
            ),
          )
        : Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            ),
            child: TextFormField(
              readOnly: readOnly,
              maxLines: maxLines,
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
                  fontSize: 13,
                ),
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
