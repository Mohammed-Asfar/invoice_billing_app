part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignInEvent extends AuthEvent {
  final String email;
  final String password;

  AuthSignInEvent({required this.email, required this.password});
}

final class AuthUserUpdateEvent extends AuthEvent {
  final String uid;
  final String email;
  final String mobileNumber;
  final File companyLogo;
  final String companyName;
  final String companyAddress;
  final String stateName;
  final String code;
  final String companyGSTIN;
  final String companyAccountNumber;
  final String bankBranch;
  final String bankName;
  final String accountIFSC;

  AuthUserUpdateEvent({
    required this.uid,
    required this.email,
    required this.mobileNumber,
    required this.companyLogo,
    required this.companyName,
    required this.companyAddress,
    required this.stateName,
    required this.code,
    required this.companyGSTIN,
    required this.companyAccountNumber,
    required this.bankBranch,
    required this.bankName,
    required this.accountIFSC,
  });
}

final class AuthForgotPassword extends AuthEvent {
  final String email;

  AuthForgotPassword({required this.email});
}
