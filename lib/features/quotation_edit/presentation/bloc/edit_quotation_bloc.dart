import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_billing_app/core/entities/quotation.dart';
import 'package:invoice_billing_app/core/entities/quotation_controller.dart';
import 'package:invoice_billing_app/core/entities/user.dart';
import 'package:invoice_billing_app/features/quotation/domain/repository/quotation_repository.dart';

part 'edit_quotation_event.dart';
part 'edit_quotation_state.dart';

class EditQuotationBloc extends Bloc<EditQuotationEvent, EditQuotationState> {
  QuotationController? quotationController;
  final QuotationRepository _quotationRepository;

  EditQuotationBloc({required QuotationRepository quotationRepository})
      : _quotationRepository = quotationRepository,
        super(EditQuotationInitial()) {
    on<EditQuotationPrint>(_onEditQuotationPrint);
    on<EditQuotationDelete>(_onEditQuotationDelete);
    on<EditQuotationUpdate>(_onEditQuotationUpdate);
  }

  void _onEditQuotationPrint(EditQuotationPrint event, Emitter emit) async {
    emit(EditQuotationLoading());
    final result = await _quotationRepository.printQuotation(
        quotation: event.quotation, user: event.user);
    result.fold(
      (failure) => emit(EditQuotationFailure(failure.message)),
      (message) => emit(EditQuotationSuccess(message: message)),
    );
  }

  void _onEditQuotationDelete(EditQuotationDelete event, Emitter emit) async {
    emit(EditQuotationLoading());
    final result = await _quotationRepository.deleteQuotation(event.quotation);
    result.fold(
      (failure) => emit(EditQuotationFailure(failure.message)),
      (message) =>
          emit(EditQuotationSuccess(message: message, isDeleted: true)),
    );
  }

  void _onEditQuotationUpdate(EditQuotationUpdate event, Emitter emit) async {
    emit(EditQuotationLoading());
    final result = await _quotationRepository.updateQuotation(event.quotation);
    result.fold(
      (failure) => emit(EditQuotationFailure(failure.message)),
      (message) =>
          emit(EditQuotationSuccess(message: message, isUpdated: true)),
    );
  }
}
