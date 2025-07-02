part of 'edit_invoice_bloc.dart';

@immutable
sealed class EditInvoiceEvent {}

final class EditInvoiceUpdate extends EditInvoiceEvent {
  final Invoice invoice;
  final User user;
  EditInvoiceUpdate({required this.invoice, required this.user});
}

final class EditInvoicePrint extends EditInvoiceEvent {
  final Invoice invoice;
  final User user;
  EditInvoicePrint({required this.invoice, required this.user});
}

final class EditInvoiceDelete extends EditInvoiceEvent {
  final Invoice invoice;
  EditInvoiceDelete({required this.invoice});
}
