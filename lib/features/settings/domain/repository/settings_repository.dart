import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:invoice_billing_app/core/domain/datasources/image_storage_datasource.dart';
import 'package:invoice_billing_app/core/domain/datasources/user_profile_datasource.dart';
import 'package:invoice_billing_app/core/entities/user.dart';
import 'package:invoice_billing_app/core/error/failure.dart';
import 'package:invoice_billing_app/core/error/server_exception.dart';

class SettingsRepository {
  final UserProfileDatasource _userProfileDatasource;
  final ImageStorageDatasource _imageStorageDatasource;

  SettingsRepository({
    required UserProfileDatasource userProfileDatasource,
    required ImageStorageDatasource imageStorageDatasource,
  })  : _userProfileDatasource = userProfileDatasource,
        _imageStorageDatasource = imageStorageDatasource;

  Future<Either<Failure, User>> userDetailsUpdate(
      {required User user, required File imageFile}) async {
    try {
      final User updatedUser = await _userProfileDatasource.userDetailsUpdate(
        uid: user.uid,
        email: user.email,
        mobileNumber: user.mobileNumber,
        companyLogo: imageFile,
        companyName: user.companyName,
        companyAddress: user.companyAddress,
        stateName: user.stateName,
        code: user.code,
        companyGSTIN: user.companyGSTIN,
        companyAccountNumber: user.companyAccountNumber,
        bankBranch: user.bankBranch,
        bankName: user.bankName,
        accountIFSC: user.accountIFSC,
      );

      return right(updatedUser);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  Future<Either<Failure, File>> fetchNetworkImage(String url) async {
    try {
      final res = await _imageStorageDatasource.fetchNetworkImage(url);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
