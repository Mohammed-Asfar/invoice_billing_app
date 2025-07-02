import 'package:cloud_firestore/cloud_firestore.dart';

class AppUserRemoteDatasource {
  final FirebaseFirestore _firebaseFirestore;

  AppUserRemoteDatasource({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  Future<Map?> getUserData({required String uid}) async {
    final Map<String, dynamic>? userData =
        (await _firebaseFirestore.collection("Users").doc(uid).get()).data();
    return userData;
  }
}
