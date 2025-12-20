part of 'quotation_bloc.dart';

abstract class QuotationState {}

class QuotationInitial extends QuotationState {}

class QuotationLoading extends QuotationState {}

class QuotationSuccess extends QuotationState {
  final String message;

  QuotationSuccess({required this.message});
}

class QuotationDeleted extends QuotationState {
  final String message;

  QuotationDeleted({required this.message});
}

class QuotationFailure extends QuotationState {
  final String message;

  QuotationFailure(this.message);
}

class QuotationListLoaded extends QuotationState {
  final List<Quotation?> quotations;

  QuotationListLoaded({required this.quotations});
}

class QuotationNumberGenerated extends QuotationState {
  final String quotationNumber;

  QuotationNumberGenerated({required this.quotationNumber});
}
