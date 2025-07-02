part of 'create_invoice_bloc.dart';

@immutable
sealed class CreateInvoiceState {}

final class CreateInvoiceInitial extends CreateInvoiceState {}

final class CreateInvoiceLoading extends CreateInvoiceState {}

final class CreateInvoiceSuccess extends CreateInvoiceState {
  final String message;

  CreateInvoiceSuccess({required this.message});
}

final class CreateInvoiceFailure extends CreateInvoiceState {
  final String message;

  CreateInvoiceFailure({required this.message});
}
