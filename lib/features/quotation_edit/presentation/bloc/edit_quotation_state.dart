part of 'edit_quotation_bloc.dart';

@immutable
abstract class EditQuotationState {}

class EditQuotationInitial extends EditQuotationState {}

class EditQuotationLoading extends EditQuotationState {}

class EditQuotationSuccess extends EditQuotationState {
  final String message;
  final bool isDeleted;
  final bool isUpdated;

  EditQuotationSuccess({
    required this.message,
    this.isDeleted = false,
    this.isUpdated = false,
  });
}

class EditQuotationFailure extends EditQuotationState {
  final String message;

  EditQuotationFailure(this.message);
}
