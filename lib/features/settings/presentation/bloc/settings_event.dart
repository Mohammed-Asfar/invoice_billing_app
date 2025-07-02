part of 'settings_bloc.dart';

@immutable
sealed class SettingsEvent {}

final class SettingsProfileSave extends SettingsEvent {
  final User user;
  final File imageFile;

  SettingsProfileSave({required this.user, required this.imageFile});
}

final class SettingsInitialize extends SettingsEvent {
  final String imageLink;

  SettingsInitialize({required this.imageLink});
}
