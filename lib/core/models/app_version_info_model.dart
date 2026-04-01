import 'package:invoice_billing_app/core/entities/app_version_info.dart';

class AppVersionInfoModel extends AppVersionInfo {
  AppVersionInfoModel({
    required super.latestVersion,
    required super.downloadUrl,
    required super.releaseNotes,
    required super.forceUpdate,
  });

  factory AppVersionInfoModel.fromMap(Map<String, dynamic> map) {
    return AppVersionInfoModel(
      latestVersion: map['latestVersion'] as String? ?? '1.0.0',
      downloadUrl: map['downloadUrl'] as String? ?? '',
      releaseNotes: map['releaseNotes'] as String? ?? '',
      forceUpdate: map['forceUpdate'] as bool? ?? false,
    );
  }
}
