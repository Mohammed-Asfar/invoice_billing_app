part of 'settings_bloc.dart';

@immutable
sealed class SettingsState {}

final class SettingsInitial extends SettingsState {}

final class SettingsLoading extends SettingsState {}

final class SettingsFailure extends SettingsState {
  final String message;

  SettingsFailure(this.message);
}

final class SettingsSuccess extends SettingsState {
  final User user;
  final String message;

  SettingsSuccess({required this.message, required this.user});
}
