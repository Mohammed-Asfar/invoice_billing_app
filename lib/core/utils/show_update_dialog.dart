import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:invoice_billing_app/core/common/widgets/basic_button.dart';
import 'package:invoice_billing_app/core/entities/app_version_info.dart';
import 'package:invoice_billing_app/core/theme/app_colors.dart';
import 'package:invoice_billing_app/core/theme/app_theme.dart';

void showUpdateDialog({
  required BuildContext context,
  required AppVersionInfo versionInfo,
}) {
  showDialog(
    context: context,
    barrierDismissible: !versionInfo.forceUpdate,
    builder: (context) {
      return Dialog(
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        ),
        child: Container(
          padding: EdgeInsets.all(24),
          constraints: BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.system_update_rounded,
                size: 48,
                color: AppColors.secondaryColor,
              ),
              SizedBox(height: 12),
              Text(
                "Update Available",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.selectedFontColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Version ${versionInfo.latestVersion}",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.secondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: double.maxFinite,
                constraints: BoxConstraints(maxHeight: 200),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.selectedFontColor.withAlpha(20),
                  borderRadius:
                      BorderRadius.circular(AppTheme.borderRadius / 2),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "What's New",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.selectedFontColor,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        versionInfo.releaseNotes,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.selectedFontColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              BasicButton(
                color: AppColors.secondaryColor,
                text: "Download Update",
                onPressed: () {
                  launchUrl(Uri.parse(versionInfo.downloadUrl));
                },
              ),
              if (!versionInfo.forceUpdate) ...[
                SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    "Later",
                    style: TextStyle(color: AppColors.fontColor),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}
