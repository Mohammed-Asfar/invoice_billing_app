import 'package:invoice_billing_app/core/entities/app_version_info.dart';

abstract class AppUpdateService {
  /// Returns version info if an update is available, null otherwise.
  Future<AppVersionInfo?> checkForUpdate();
}
