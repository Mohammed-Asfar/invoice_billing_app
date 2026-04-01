import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_billing_app/core/entities/invoice.dart';
import 'package:invoice_billing_app/core/entities/invoice_controller.dart';
import 'package:invoice_billing_app/core/entities/user.dart';
import 'package:invoice_billing_app/features/invoice/domain/repository/invoice_repository.dart';
import 'package:invoice_billing_app/features/invoice/domain/usecase/create_invoice_usecase.dart';

part 'create_invoice_event.dart';
part 'create_invoice_state.dart';

class CreateInvoiceBloc extends Bloc<CreateInvoiceEvent, CreateInvoiceState> {
  final CreateInvoiceUseCase _createInvoiceUseCase;
  final CreateInvoiceRepository _createInvoiceRepository;
  InvoiceController? invoiceController;

  CreateInvoiceBloc({
    required CreateInvoiceUseCase createInvoiceUseCase,
    required CreateInvoiceRepository createInvoiceRepository,
  })  : _createInvoiceUseCase = createInvoiceUseCase,
        _createInvoiceRepository = createInvoiceRepository,
        super(CreateInvoiceInitial()) {
    on<CreateInvoice>(_onCreateInvoice);
    on<CreateInvoiceGetInvoiceNo>(_onCreateInvoiceGetInvoiceNo);
  }

  void _onCreateInvoice(CreateInvoice event, Emitter emit) async {
    emit(CreateInvoiceLoading());
    final result = await _createInvoiceUseCase(
      CreateInvoiceParams(invoice: event.invoice, user: event.user),
    );
    result.fold(
      (failure) => emit(CreateInvoiceFailure(message: failure.message)),
      (message) async {
        invoiceController = InvoiceController();
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
        invoiceController!.invoiceNoController.text = invoiceNo;
        emit(CreateInvoiceSuccess(message: ""));
      },
    );
  }
}
