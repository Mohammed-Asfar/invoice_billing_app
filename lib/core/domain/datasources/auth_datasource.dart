import 'dart:io';
import 'package:invoice_billing_app/core/entities/user.dart';

/// Abstraction for authentication-related operations.
/// Handles sign-in, password reset, user profile updates, and image management.
abstract class AuthDatasource {
  /// Sign in with email and password. Returns a map with user info.
  Future<Map> signWithEmailPassword(
      {required String email, required String password});

  /// Upload an image to cloud storage and return its download URL.
  Future<String> uploadImage(File image, String uid);

  /// Send a password reset email.
  Future<String> forgotPassword({required String email});

  /// Update user details in the database.
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
  });

  /// Fetch an image from a remote URL and return it as a local file.
  Future<File> fetchNetworkImage(String url);
}
