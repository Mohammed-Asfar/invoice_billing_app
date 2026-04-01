import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invoice_billing_app/core/domain/datasources/image_storage_datasource.dart';
import 'package:invoice_billing_app/core/domain/datasources/user_profile_datasource.dart';
import 'package:invoice_billing_app/core/entities/user.dart';
import 'package:invoice_billing_app/core/error/server_exception.dart';
import 'package:invoice_billing_app/core/models/user_model.dart';
import 'package:invoice_billing_app/core/network_handle/check_connection.dart';

/// Firestore implementation of [UserProfileDatasource].
/// Depends on [ImageStorageDatasource] for logo upload.
class UserProfileRemoteDatasource implements UserProfileDatasource {
  final FirebaseFirestore _firebaseFirestore;
  final ImageStorageDatasource _imageStorageDatasource;

  UserProfileRemoteDatasource({
    required FirebaseFirestore firebaseFirestore,
    required ImageStorageDatasource imageStorageDatasource,
  })  : _firebaseFirestore = firebaseFirestore,
        _imageStorageDatasource = imageStorageDatasource;

  @override
  Future<User> userDetailsUpdate({
    required String uid,
    required String email,
    required String mobileNumber,
    required File companyLogo,
    required String companyName,
    required String companyAddress,
    required String stateName,
    required String code,
    required String companyGSTIN,
    required String companyAccountNumber,
    required String bankBranch,
    required String bankName,
    required String accountIFSC,
  }) async {
    if (await checkConnection()) {
      throw ServerException("No Internet Connection.");
    }
    try {
      final collection = _firebaseFirestore.collection("Users");
      final imageUrl =
          await _imageStorageDatasource.uploadImage(companyLogo, uid);

      final map = {
        'uid': uid,
        'email': email,
        'mobileNumber': mobileNumber,
        'companyLogo': imageUrl,
        'companyName': companyName,
        'companyAddress': companyAddress,
        'stateName': stateName,
        'code': code,
        'companyGSTIN': companyGSTIN,
        'companyAccountNumber': companyAccountNumber,
        'bankBranch': bankBranch,
        'bankName': bankName,
        'accountIFSC': accountIFSC,
      };
      await collection.doc(uid).set(map);
      return UserModel.fromMap(map);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
