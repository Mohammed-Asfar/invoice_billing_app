import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_billing_app/core/entities/user.dart';
import 'package:invoice_billing_app/features/settings/domain/repository/settings_repository.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _settingsRepository;
  File? logo;

  SettingsBloc({required SettingsRepository settingsRepository})
      : _settingsRepository = settingsRepository,
        super(SettingsInitial()) {
    on<SettingsProfileSave>(_onSettingsProfileSave);
    on<SettingsInitialize>(_onSettingsInitialize);
  }

  void _onSettingsProfileSave(
      SettingsProfileSave event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    final result = await _settingsRepository.userDetailsUpdate(
        user: event.user, imageFile: event.imageFile);

    result.fold(
      (failure) => emit(SettingsFailure(failure.message)),
      (user) {
        emit(SettingsSuccess(
            user: user, message: "User data successfully updated"));
      },
    );
  }

  void _onSettingsInitialize(
      SettingsInitialize event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    final result = await _settingsRepository.fetchNetworkImage(event.imageLink);
    result.fold(
      (failure) => emit(SettingsFailure(failure.message)),
      (image) {
        logo = image;
        emit(SettingsInitial());
      },
    );
  }
}
