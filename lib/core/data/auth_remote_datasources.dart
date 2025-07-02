import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fauth;
import 'package:invoice_billing_app/core/entities/user.dart';
import 'package:invoice_billing_app/core/error/server_exception.dart';
import 'package:invoice_billing_app/core/models/user_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:invoice_billing_app/core/network_handle/check_connection.dart';
import 'package:invoice_billing_app/core/secrets/secrets.dart';
import 'package:path_provider/path_provider.dart';

class AuthRemoteDatasources {
  final fauth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  AuthRemoteDatasources({
    required fauth.FirebaseAuth firebaseAuth,
    required FirebaseFirestore firebaseFirestore,
  })  : _firebaseAuth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore;

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

  Future<String> uploadToImgur(File image) async {
    final url = Uri.parse('https://api.imgur.com/3/upload');
    final headers = {
      'Authorization': 'Client-ID ${Secrets.imgurClientId}',
    };

    final request = http.MultipartRequest('POST', url)
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath('image', image.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      return json.decode(responseData)['data']['link'];
    } else {
      throw ServerException("Something went wrong");
    }
  }

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
      final imageUrl = await uploadToImgur(companyLogo);

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

  Future<File> fetchNetworkImage(String url) async {
    if (await checkConnection()) {
      throw ServerException("No Internet Connection.");
    }
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Get temporary directory
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/downloaded_image.png';

        // Write image bytes to file
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        return file;
      } else {
        throw ServerException("Failed to load image: ${response.statusCode}");
      }
    } catch (e) {
      throw ServerException("Error fetching image: $e");
    }
  }
}
