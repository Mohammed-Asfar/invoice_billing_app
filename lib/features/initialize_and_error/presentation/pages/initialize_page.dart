import 'package:flutter/material.dart';
import 'package:invoice_billing_app/core/assets/app_image.dart';
import 'package:invoice_billing_app/core/theme/app_colors.dart';
import 'package:invoice_billing_app/core/theme/app_theme.dart';
import 'package:invoice_billing_app/main.dart';

class InitializePage extends StatelessWidget {
  const InitializePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Container(
        decoration: AppTheme.backgroundColor2Theme,
        child: WindowTitleBar(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: CircleAvatar(
                    maxRadius: 80,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage(AppImage.iconPath),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 200,
                  child: LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(20),
                    backgroundColor:
                        AppColors.secondaryColor.withValues(alpha: 0.2),
                    color: AppColors.secondaryColor,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
