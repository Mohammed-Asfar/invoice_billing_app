import 'dart:io';
import 'package:invoice_billing_app/core/entities/user.dart';

/// Abstraction for user profile CRUD operations.
abstract class UserProfileDatasource {
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
}
