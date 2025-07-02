import 'package:flutter/material.dart';
import 'package:invoice_billing_app/core/theme/app_colors.dart';

class HighlightButton extends StatelessWidget {
  final bool isSelected;
  final String step;
  final String title;
  final String description;
  final VoidCallback onTap;
  const HighlightButton({
    super.key,
    required this.isSelected,
    required this.step,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width / 4.5,
        child: ListTile(
          leading: Container(
            decoration: BoxDecoration(
              border: isSelected
                  ? Border.all(
                      width: 1,
                      color: AppColors.secondaryColor,
                    )
                  : null,
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(2),
            child: CircleAvatar(
              maxRadius: 17,
              backgroundColor: AppColors.secondaryColor,
              child: Text(step),
            ),
          ),
          title: Text(
            title,
            style: TextStyle(fontSize: 14),
          ),
          subtitle: Text(description, style: TextStyle(fontSize: 12)),
        ),
      ),
    );
  }
}
