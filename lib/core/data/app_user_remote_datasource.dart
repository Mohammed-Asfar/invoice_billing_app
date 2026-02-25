import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invoice_billing_app/core/domain/datasources/app_user_datasource.dart';

class AppUserRemoteDatasource implements AppUserDatasource {
  final FirebaseFirestore _firebaseFirestore;

  AppUserRemoteDatasource({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  @override
  Future<Map?> getUserData({required String uid}) async {
    final Map<String, dynamic>? userData =
        (await _firebaseFirestore.collection("Users").doc(uid).get()).data();
    return userData;
  }
}
