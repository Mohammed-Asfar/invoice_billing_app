import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_billing_app/core/cubit/app_user/app_user_cubit.dart';
import 'package:invoice_billing_app/core/entities/invoice.dart';
import 'package:invoice_billing_app/core/entities/invoice_controller.dart';
import 'package:invoice_billing_app/core/entities/user.dart';
import 'package:invoice_billing_app/features/invoice/domain/repository/invoice_repository.dart';

part 'create_invoice_event.dart';
part 'create_invoice_state.dart';

class CreateInvoiceBloc extends Bloc<CreateInvoiceEvent, CreateInvoiceState> {
  final CreateInvoiceRepository _createInvoiceRepository;
  final AppUserCubit _appUserCubit;
  CreateInvoiceBloc(
      {required CreateInvoiceRepository createInvoiceRepository,
      required AppUserCubit appUserCubit})
      : _createInvoiceRepository = createInvoiceRepository,
        _appUserCubit = appUserCubit,
        super(CreateInvoiceInitial()) {
    on<CreateInvoice>(_onCreateInvoice);
    on<CreateInvoiceGetInvoiceNo>(_onCreateInvoiceGetInvoiceNo);
  }

  void _onCreateInvoice(CreateInvoice event, Emitter emit) async {
    emit(CreateInvoiceLoading());
    final result = await _createInvoiceRepository.createInvoice(
        invoice: event.invoice, user: event.user);
    result.fold(
      (failure) => emit(CreateInvoiceFailure(message: failure.message)),
      (message) async {
        _appUserCubit.invoiceController = InvoiceController();
        emit(CreateInvoiceSuccess(message: message));
      },
    );
  }

  void _onCreateInvoiceGetInvoiceNo(
      CreateInvoiceGetInvoiceNo event, Emitter emit) async {
    final result = await _createInvoiceRepository.getNextInvoiceNumber();
    result.fold(
      (failure) => emit(CreateInvoiceFailure(message: failure.message)),
      (invoiceNo) {
        _appUserCubit.invoiceController!.invoiceNoController.text = invoiceNo;
        emit(CreateInvoiceSuccess(message: ""));
      },
    );
  }
}
