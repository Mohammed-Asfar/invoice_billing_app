import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_billing_app/core/entities/invoice.dart';
import 'package:invoice_billing_app/core/entities/invoice_controller.dart';
import 'package:invoice_billing_app/core/entities/user.dart';
import 'package:invoice_billing_app/features/invoice_edit/domain/repository/edit_invoice_repository.dart';

part 'edit_invoice_event.dart';
part 'edit_invoice_state.dart';

class EditInvoiceBloc extends Bloc<EditInvoiceEvent, EditInvoiceState> {
  InvoiceController? invoiceController;
  final EditInvoiceRepository _editInvoiceRepository;

  EditInvoiceBloc({required EditInvoiceRepository editInvoiceRepository})
      : _editInvoiceRepository = editInvoiceRepository,
        super(EditInvoiceInitial()) {
    on<EditInvoicePrint>(_onEditInvoicePrint);
    on<EditInvoiceDelete>(_onEditInvoiceDelete);
    on<EditInvoiceUpdate>(_onEditInvoiceUpdate);
  }

  void _onEditInvoicePrint(EditInvoicePrint event, Emitter emit) async {
    emit(EditInvoiceLoading());
    final result = await _editInvoiceRepository.printInvoice(
        invoice: event.invoice, user: event.user);
    result.fold(
      (failure) => emit(EditInvoiceFailure(failure.message)),
      (message) => emit(EditInvoiceSuccess(message: message)),
    );
  }

  void _onEditInvoiceDelete(EditInvoiceDelete event, Emitter emit) async {
    emit(EditInvoiceLoading());
    final result =
        await _editInvoiceRepository.deleteInvoice(invoice: event.invoice);
    result.fold(
      (failure) => emit(EditInvoiceFailure(failure.message)),
      (message) =>
          emit(EditInvoiceSuccess(message: message, isDialogOpen: true)),
    );
  }

  void _onEditInvoiceUpdate(EditInvoiceUpdate event, Emitter emit) async {
    emit(EditInvoiceLoading());
    final result =
        await _editInvoiceRepository.updateInvoice(invoice: event.invoice);
    result.fold(
      (failure) => emit(EditInvoiceFailure(failure.message)),
      (message) =>
          emit(EditInvoiceSuccess(message: message, isDialogOpen: true)),
    );
  }
}
