import 'package:flutter/material.dart';
import 'package:invoice_billing_app/core/common/widgets/basic_button.dart';
import 'package:invoice_billing_app/core/theme/app_colors.dart';

class EditPageHeader extends StatelessWidget {
  final int selectedStep;
  final String title;
  final String buttonText;
  final void Function() onPressed;
  final void Function() iconPressed;
  final void Function() printOnPressed;
  final void Function() deleteOnPressed;

  const EditPageHeader({
    super.key,
    required this.selectedStep,
    required this.title,
    required this.onPressed,
    required this.buttonText,
    required this.iconPressed,
    required this.printOnPressed,
    required this.deleteOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: iconPressed,
            icon: Icon(Icons.arrow_back_ios_new_rounded),
          ),
          SizedBox(
            width: 10,
          ),

          // Title
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
          ),

          // Buttons
          Row(
            children: [
              if (selectedStep == 1)
                BasicButton(
                  color: AppColors.primaryColor,
                  width: 150,
                  text: "Print",
                  onPressed: printOnPressed,
                ),
              const SizedBox(width: 10), // Spacing between buttons
              BasicButton(
                color: AppColors.primaryColor,
                width: selectedStep == 0 ? 150 : 200,
                text: buttonText,
                onPressed: onPressed,
              ),
              const SizedBox(width: 10), // Spacing between buttons
              BasicButton(
                color: Colors.red,
                width: 150,
                text: "delete",
                onPressed: deleteOnPressed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
