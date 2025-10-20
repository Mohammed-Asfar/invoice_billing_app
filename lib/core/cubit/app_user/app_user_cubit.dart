import 'package:firebase_auth/firebase_auth.dart' as fauth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_billing_app/core/data/app_user_remote_datasource.dart';
import 'package:invoice_billing_app/core/entities/invoice_controller.dart';
import 'package:invoice_billing_app/core/entities/quotation_controller.dart';
import 'package:invoice_billing_app/core/entities/user.dart';
import 'package:invoice_billing_app/core/models/user_model.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  final fauth.FirebaseAuth _firebaseAuth;
  final AppUserRemoteDatasource _appUserRemoteDatasource;
  late User user;
  InvoiceController? invoiceController;
  QuotationController? quotationController;
  late final Stream<fauth.User?> loginStream;
  final TextEditingController searchBarController = TextEditingController();
  AppUserCubit(
      {required fauth.FirebaseAuth firebaseAuth,
      required AppUserRemoteDatasource appUserRemoteDatasource})
      : _firebaseAuth = firebaseAuth,
        _appUserRemoteDatasource = appUserRemoteDatasource,
        super(AppUserInitial()) {
    loginStream = _firebaseAuth.authStateChanges();
  }

  Future<void> updateUser() async {
    emit(AppUserLoading());

    try {
      loginStream.listen((user_) async {
        emit(AppUserLoading());

        if (user_ != null) {
          final data =
              await _appUserRemoteDatasource.getUserData(uid: user_.uid);
          if (data != null) {
            user = UserModel.fromMap(data as Map<String, dynamic>);
            emit(AppUserLoggedIn(user));
          } else {
            emit(
                AppUserDetailsUpdate(uid: user_.uid, email: user_.email ?? ''));
          }
        } else {
          emit(AppUserInitial());
        }
      });
    } catch (e) {
      emit(AppUserFailure(e.toString()));
    }
  }

  void userLogout() async {
    emit(AppUserLoading());
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      emit(AppUserFailure(e.toString()));
    }
  }
}
