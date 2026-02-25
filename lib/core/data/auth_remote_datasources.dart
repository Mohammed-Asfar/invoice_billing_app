import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fauth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:invoice_billing_app/core/domain/datasources/auth_datasource.dart';
import 'package:invoice_billing_app/core/entities/user.dart';
import 'package:invoice_billing_app/core/error/server_exception.dart';
import 'package:invoice_billing_app/core/models/user_model.dart';
import 'package:invoice_billing_app/core/network_handle/check_connection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class AuthRemoteDatasources implements AuthDatasource {
  final fauth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;

  AuthRemoteDatasources({
    required fauth.FirebaseAuth firebaseAuth,
    required FirebaseFirestore firebaseFirestore,
    required FirebaseStorage firebaseStorage,
  })  : _firebaseAuth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore,
        _firebaseStorage = firebaseStorage;

  @override
  Future<Map> signWithEmailPassword(
      {required String email, required String password}) async {
    if (await checkConnection()) {
      throw ServerException("No Internet Connection.");
    }
    try {
      final user = (await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user!;

      return {"uid": user.uid};
    } on fauth.FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? "Something went wrong.");
    } catch (e) {
      throw ServerException("Something went wrong.");
    }
  }

  @override
  Future<String> uploadImage(File image, String uid) async {
    try {
      final ref = _firebaseStorage.ref().child('company_logos/$uid');
      await ref.putFile(image);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw ServerException("Error uploading image: $e");
    }
  }

  @override
  Future<String> forgotPassword({required String email}) async {
    if (await checkConnection()) {
      throw ServerException("No Internet Connection.");
    }
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return "Reset link is sent to $email";
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

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
      final imageUrl = await uploadImage(companyLogo, uid);

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

  @override
  Future<File> fetchNetworkImage(String url) async {
    if (await checkConnection()) {
      throw ServerException("No Internet Connection.");
    }
    try {
      // Download from Firebase Storage URL
      final ref = _firebaseStorage.refFromURL(url);
      final directory = await getTemporaryDirectory();
      final filePath = p.join(directory.path, 'downloaded_image.png');
      final file = File(filePath);
      await ref.writeToFile(file);
      return file;
    } catch (e) {
      throw ServerException("Error fetching image: $e");
    }
  }
}
