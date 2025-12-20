part of 'quotation_bloc.dart';

abstract class QuotationEvent {}

class CreateQuotation extends QuotationEvent {
  final Quotation quotation;

  CreateQuotation(this.quotation);
}

class UpdateQuotation extends QuotationEvent {
  final Quotation quotation;

  UpdateQuotation(this.quotation);
}

class PrintQuotation extends QuotationEvent {
  final Quotation quotation;
  final User user;

  PrintQuotation({required this.quotation, required this.user});
}

class QuotationSearch extends QuotationEvent {
  final String searchText;

  QuotationSearch(this.searchText);
}

class DeleteQuotation extends QuotationEvent {
  final Quotation quotation;

  DeleteQuotation(this.quotation);
}

class GetNextQuotationNumber extends QuotationEvent {}
