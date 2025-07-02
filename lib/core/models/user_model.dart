// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:invoice_billing_app/core/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.uid,
    required super.email,
    required super.mobileNumber,
    required super.companyLogo,
    required super.companyName,
    required super.companyAddress,
    required super.stateName,
    required super.code,
    required super.companyGSTIN,
    required super.companyAccountNumber,
    required super.bankBranch,
    required super.bankName,
    required super.accountIFSC,
  });

  UserModel copyWith({
    String? uid,
    String? email,
    String? mobileNumber,
    String? companyLogo,
    String? companyName,
    String? companyAddress,
    String? stateName,
    String? code,
    String? companyGSTIN,
    String? companyAccountNumber,
    String? bankBranch,
    String? bankName,
    String? accountIFSC,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      companyLogo: companyLogo ?? this.companyLogo,
      companyName: companyName ?? this.companyName,
      companyAddress: companyAddress ?? this.companyAddress,
      stateName: stateName ?? this.stateName,
      code: code ?? this.code,
      companyGSTIN: companyGSTIN ?? this.companyGSTIN,
      companyAccountNumber: companyAccountNumber ?? this.companyAccountNumber,
      bankBranch: bankBranch ?? this.bankBranch,
      bankName: bankName ?? this.bankName,
      accountIFSC: accountIFSC ?? this.accountIFSC,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'mobileNumber': mobileNumber,
      'companyLogo': companyLogo,
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
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      email: map['email'] as String,
      mobileNumber: map['mobileNumber'] as String,
      companyLogo: map['companyLogo'] as String,
      companyName: map['companyName'] as String,
      companyAddress: map['companyAddress'] as String,
      stateName: map['stateName'] as String,
      code: map['code'] as String,
      companyGSTIN: map['companyGSTIN'] as String,
      companyAccountNumber: map['companyAccountNumber'] as String,
      bankBranch: map['bankBranch'] as String,
      bankName: map['bankName'] as String,
      accountIFSC: map['accountIFSC'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, mobileNumber: $mobileNumber, companyLogo: $companyLogo, companyName: $companyName, companyAddress: $companyAddress, stateName: $stateName, code: $code, companyGSTIN: $companyGSTIN, companyAccountNumber: $companyAccountNumber, bankBranch: $bankBranch, bankName: $bankName, accountIFSC: $accountIFSC)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.email == email &&
        other.mobileNumber == mobileNumber &&
        other.companyLogo == companyLogo &&
        other.companyName == companyName &&
        other.companyAddress == companyAddress &&
        other.stateName == stateName &&
        other.code == code &&
        other.companyGSTIN == companyGSTIN &&
        other.companyAccountNumber == companyAccountNumber &&
        other.bankBranch == bankBranch &&
        other.bankName == bankName &&
        other.accountIFSC == accountIFSC;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        email.hashCode ^
        mobileNumber.hashCode ^
        companyLogo.hashCode ^
        companyName.hashCode ^
        companyAddress.hashCode ^
        stateName.hashCode ^
        code.hashCode ^
        companyGSTIN.hashCode ^
        companyAccountNumber.hashCode ^
        bankBranch.hashCode ^
        bankName.hashCode ^
        accountIFSC.hashCode;
  }
}
