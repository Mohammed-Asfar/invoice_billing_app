import 'package:flutter/material.dart';
import 'package:invoice_billing_app/core/common/widgets/basic_button.dart';
import 'package:invoice_billing_app/core/theme/app_colors.dart';
import 'package:invoice_billing_app/core/theme/app_theme.dart';

void showAppDialog({
  required BuildContext context,
  required VoidCallback onPressed,
  required String title,
  required String text,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return Container(
        decoration: AppTheme.backgroundColor2Theme,
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(text),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BasicButton(
                        color: AppColors.primaryColor,
                        width: 100,
                        text: "Yes",
                        onPressed: onPressed,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      BasicButton(
                          width: 100,
                          text: "No",
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
