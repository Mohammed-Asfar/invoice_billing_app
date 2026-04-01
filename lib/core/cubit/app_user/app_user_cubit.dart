import 'package:firebase_auth/firebase_auth.dart' as fauth;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_billing_app/core/domain/datasources/app_user_datasource.dart';
import 'package:invoice_billing_app/core/entities/user.dart';
import 'package:invoice_billing_app/core/models/user_model.dart';
import 'package:flutter/foundation.dart';

part 'app_user_state.dart';

/// Cubit responsible only for authentication state and current user data.
/// Controllers for invoice, quotation, and search have been moved to
/// their respective blocs/widgets.
class AppUserCubit extends Cubit<AppUserState> {
  final fauth.FirebaseAuth _firebaseAuth;
  final AppUserDatasource _appUserRemoteDatasource;
  late User user;
  late final Stream<fauth.User?> loginStream;

  AppUserCubit(
      {required fauth.FirebaseAuth firebaseAuth,
      required AppUserDatasource appUserRemoteDatasource})
      : _firebaseAuth = firebaseAuth,
        _appUserRemoteDatasource = appUserRemoteDatasource,
        super(AppUserInitial()) {
    loginStream = _firebaseAuth.authStateChanges();
  }

  Future<void> updateUser() async {
    if (isClosed) return;
    emit(AppUserLoading());

    try {
      loginStream.listen((user_) async {
        if (isClosed) return;
        emit(AppUserLoading());

        if (user_ != null) {
          final data =
              await _appUserRemoteDatasource.getUserData(uid: user_.uid);
          if (isClosed) return;
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
      if (isClosed) return;
      emit(AppUserFailure(e.toString()));
    }
  }

  void userLogout() async {
    if (isClosed) return;
    emit(AppUserLoading());
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      if (isClosed) return;
      emit(AppUserFailure(e.toString()));
    }
  }
}
