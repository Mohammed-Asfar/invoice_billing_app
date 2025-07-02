import 'package:flutter/material.dart';
import 'package:invoice_billing_app/core/theme/app_colors.dart';
import 'package:invoice_billing_app/core/theme/app_theme.dart';

class NavigatorListTile extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String title;
  final bool isSelected;
  final bool ishidden;
  final bool isAnimationOver;

  const NavigatorListTile({
    super.key,
    required this.ishidden,
    required this.isAnimationOver,
    required this.isSelected,
    required this.onTap,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ishidden
        ? _iconWidget()
        : isAnimationOver
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  // gradient: isSelected
                  //     ? LinearGradient(
                  //         colors: [
                  //           AppColors.primaryColor,
                  //           AppColors.secondaryColor
                  //         ],
                  //         begin: Alignment.bottomLeft,
                  //         end: Alignment.topRight,
                  //       )
                  //     : null,
                  color: isSelected ? AppColors.secondaryColor : null,
                ),
                margin: EdgeInsets.all(5),
                child: ListTile(
                  leading: Icon(
                    icon,
                    color: isSelected
                        ? AppColors.selectedFontColor
                        : AppColors.fontColor,
                    size: 22,
                  ),
                  title: Text(
                    title,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.selectedFontColor
                          : AppColors.fontColor,
                      fontWeight: isSelected ? FontWeight.w500 : null,
                      fontSize: 13,
                    ),
                  ),
                  onTap: onTap,
                ),
              )
            : _iconWidget();
  }

  Widget _iconWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        // gradient: isSelected
        //     ? LinearGradient(
        //         colors: [
        //           AppColors.primaryColor,
        //           AppColors.secondaryColor
        //         ],
        //         begin: Alignment.bottomLeft,
        //         end: Alignment.topRight,
        //       )
        //     : null,
        color: isSelected ? AppColors.secondaryColor : null,
      ),
      margin: EdgeInsets.all(5),
      child: IconButton(
          onPressed: onTap,
          icon: Icon(
            icon,
            color:
                isSelected ? AppColors.selectedFontColor : AppColors.fontColor,
          )),
    );
  }
}
