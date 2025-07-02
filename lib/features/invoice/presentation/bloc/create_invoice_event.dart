part of 'create_invoice_bloc.dart';

@immutable
sealed class CreateInvoiceEvent {}

class CreateInvoice extends CreateInvoiceEvent {
  final Invoice invoice;
  final User user;

  CreateInvoice({required this.invoice, required this.user});
}

class CreateInvoiceGetInvoiceNo extends CreateInvoiceEvent {}
