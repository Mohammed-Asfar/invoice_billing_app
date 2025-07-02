import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:invoice_billing_app/core/entities/user.dart';
import 'package:invoice_billing_app/core/error/failure.dart';
import 'package:invoice_billing_app/core/error/server_exception.dart';
import 'package:invoice_billing_app/core/data/auth_remote_datasources.dart';

class AuthRepository {
  final AuthRemoteDatasources authRemoteDatasources;
  AuthRepository({required this.authRemoteDatasources});

  Future<Either<Failure, User>> signWithEmailPassword(
      {required String email, required String password}) async {
    try {
      final user = (await authRemoteDatasources.signWithEmailPassword(
          email: email, password: password));

      return right(
        User(
          uid: user["uid"],
          email: email,
          mobileNumber: user["mobileNumber"] ?? "",
          companyLogo: user["companyLogo"] ?? "",
          companyName: user["companyName"] ?? "",
          companyAddress: user["companyAddress"] ?? "",
          stateName: user["stateName"] ?? "",
          code: user["code"] ?? "",
          companyGSTIN: user["companyGSTIN"] ?? "",
          companyAccountNumber: user["companyAccountNumber"] ?? "",
          bankBranch: user["bankBranch"] ?? "",
          accountIFSC: user["accountIFSC"] ?? "",
          bankName: user["accountIFSC"] ?? "",
        ),
      );
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  Future<Either<Failure, String>> forgotPassword(
      {required String email}) async {
    try {
      final res = await authRemoteDatasources.forgotPassword(email: email);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  Future<Either<Failure, User>> userDetailsUpdate({
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
    try {
      final User user = await authRemoteDatasources.userDetailsUpdate(
        uid: uid,
        email: email,
        mobileNumber: mobileNumber,
        companyLogo: companyLogo,
        companyName: companyName,
        companyAddress: companyAddress,
        stateName: stateName,
        code: code,
        companyGSTIN: companyGSTIN,
        companyAccountNumber: companyAccountNumber,
        bankBranch: bankBranch,
        bankName: bankName,
        accountIFSC: accountIFSC,
      );

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
