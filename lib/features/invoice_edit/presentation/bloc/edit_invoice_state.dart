part of 'edit_invoice_bloc.dart';

@immutable
sealed class EditInvoiceState {}

final class EditInvoiceInitial extends EditInvoiceState {}

final class EditInvoiceLoading extends EditInvoiceState {}

final class EditInvoiceDialogLoading extends EditInvoiceState {}

final class EditInvoiceFailure extends EditInvoiceState {
  final String message;

  EditInvoiceFailure(this.message);
}

final class EditInvoiceSuccess extends EditInvoiceState {
  final Invoice? invoice;
  final bool isDialogOpen;
  final String message;

  EditInvoiceSuccess(
      {this.invoice, required this.message, this.isDialogOpen = false});
}
