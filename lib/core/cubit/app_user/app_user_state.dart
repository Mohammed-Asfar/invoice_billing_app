part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState {}

final class AppUserInitial extends AppUserState {}

final class AppUserNotLoggedIn extends AppUserState {}

final class AppUserLoading extends AppUserState {}

final class AppUserFailure extends AppUserState {
  final String message;
  AppUserFailure(this.message);
}

final class AppUserLoggedIn extends AppUserState {
  final User user;
  AppUserLoggedIn(this.user);
}

final class AppUserDetailsUpdate extends AppUserState {
  final String uid;
  final String email;
  AppUserDetailsUpdate({required this.uid, required this.email});
}
