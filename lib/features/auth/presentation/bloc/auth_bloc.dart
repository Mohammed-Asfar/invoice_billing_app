import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_billing_app/core/entities/user.dart';
import 'package:invoice_billing_app/features/auth/domain/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  AuthBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignInEvent>(_onAuthSignInEvent);
    on<AuthForgotPassword>(_onAuthForgotPassword);
    on<AuthUserUpdateEvent>(_onAuthUserUpdateEvent);
  }

  void _onAuthSignInEvent(AuthSignInEvent event, Emitter emit) async {
    final res = await _authRepository.signWithEmailPassword(
      email: event.email,
      password: event.password,
    );

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (user) {
        emit(AuthSuccess(user));
      },
    );
  }

  void _onAuthUserUpdateEvent(AuthUserUpdateEvent event, Emitter emit) async {
    final res = await _authRepository.userDetailsUpdate(
      uid: event.uid,
      email: event.email,
      mobileNumber: event.mobileNumber,
      companyLogo: event.companyLogo,
      companyName: event.companyName,
      companyAddress: event.companyAddress,
      stateName: event.stateName,
      code: event.code,
      companyGSTIN: event.companyGSTIN,
      companyAccountNumber: event.companyAccountNumber,
      bankBranch: event.bankBranch,
      bankName: event.bankName,
      accountIFSC: event.accountIFSC,
    );

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (user) {
        emit(AuthSuccess(user));
      },
    );
  }

  void _onAuthForgotPassword(AuthForgotPassword event, Emitter emit) async {
    final result = await _authRepository.forgotPassword(email: event.email);
    result.fold((failure) => emit(AuthFailure(failure.message)),
        (message) => emit(AuthForgotSuccess(message: message)));
  }
}
