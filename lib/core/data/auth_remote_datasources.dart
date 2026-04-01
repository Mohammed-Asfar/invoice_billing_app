import 'package:firebase_auth/firebase_auth.dart' as fauth;
import 'package:invoice_billing_app/core/domain/datasources/auth_datasource.dart';
import 'package:invoice_billing_app/core/error/server_exception.dart';
import 'package:invoice_billing_app/core/network_handle/check_connection.dart';

/// Firebase implementation of [AuthDatasource].
/// Handles only authentication: sign-in and password reset.
class AuthRemoteDatasource implements AuthDatasource {
  final fauth.FirebaseAuth _firebaseAuth;

  AuthRemoteDatasource({required fauth.FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

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
}
