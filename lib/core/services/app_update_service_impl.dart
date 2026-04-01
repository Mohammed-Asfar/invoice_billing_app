import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invoice_billing_app/core/domain/services/app_update_service.dart';
import 'package:invoice_billing_app/core/entities/app_version_info.dart';
import 'package:invoice_billing_app/core/models/app_version_info_model.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppUpdateServiceImpl implements AppUpdateService {
  final FirebaseFirestore _firestore;

  AppUpdateServiceImpl({required FirebaseFirestore firebaseFirestore})
      : _firestore = firebaseFirestore;

  @override
  Future<AppVersionInfo?> checkForUpdate() async {
    try {
      final doc =
          await _firestore.collection('app_config').doc('version').get();

      if (!doc.exists || doc.data() == null) return null;

      final versionInfo = AppVersionInfoModel.fromMap(doc.data()!);
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      if (_isNewer(versionInfo.latestVersion, currentVersion)) {
        return versionInfo;
      }
      return null;
    } catch (_) {
      // Update check should never block app usage
      return null;
    }
  }

  /// Returns true if [remote] is a newer semver than [current].
  bool _isNewer(String remote, String current) {
    final r = remote.split('.').map(int.parse).toList();
    final c = current.split('.').map(int.parse).toList();
    for (int i = 0; i < 3; i++) {
      final rv = i < r.length ? r[i] : 0;
      final cv = i < c.length ? c[i] : 0;
      if (rv > cv) return true;
      if (rv < cv) return false;
    }
    return false;
  }
}
