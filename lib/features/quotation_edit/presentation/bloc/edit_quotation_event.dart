part of 'edit_quotation_bloc.dart';

@immutable
abstract class EditQuotationEvent {}

class EditQuotationPrint extends EditQuotationEvent {
  final Quotation quotation;
  final User user;

  EditQuotationPrint({required this.quotation, required this.user});
}

class EditQuotationDelete extends EditQuotationEvent {
  final Quotation quotation;

  EditQuotationDelete({required this.quotation});
}

class EditQuotationUpdate extends EditQuotationEvent {
  final Quotation quotation;

  EditQuotationUpdate({required this.quotation});
}
