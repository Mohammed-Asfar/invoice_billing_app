import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_billing_app/core/cubit/app_user/app_user_cubit.dart';
import 'package:invoice_billing_app/core/entities/quotation.dart';
import 'package:invoice_billing_app/core/entities/user.dart';
import 'package:invoice_billing_app/features/quotation/domain/repository/quotation_repository.dart';

part 'quotation_event.dart';
part 'quotation_state.dart';

class QuotationBloc extends Bloc<QuotationEvent, QuotationState> {
  final QuotationRepository _quotationRepository;
  final AppUserCubit _appUserCubit;

  QuotationBloc({
    required QuotationRepository quotationRepository,
    required AppUserCubit appUserCubit,
  })  : _quotationRepository = quotationRepository,
        _appUserCubit = appUserCubit,
        super(QuotationInitial()) {
    on<CreateQuotation>(_onCreateQuotation);
    on<UpdateQuotation>(_onUpdateQuotation);
    on<PrintQuotation>(_onPrintQuotation);
    on<QuotationSearch>(_onQuotationSearch);
    on<DeleteQuotation>(_onDeleteQuotation);
    on<GetNextQuotationNumber>(_onGetNextQuotationNumber);
  }

  void _onCreateQuotation(
      CreateQuotation event, Emitter<QuotationState> emit) async {
    emit(QuotationLoading());

    final result = await _quotationRepository.uploadQuotation(
      quotation: event.quotation,
      user: _appUserCubit.user,
    );

    result.fold(
      (failure) => emit(QuotationFailure(failure.message)),
      (message) => emit(QuotationSuccess(message: message)),
    );
  }

  void _onUpdateQuotation(
      UpdateQuotation event, Emitter<QuotationState> emit) async {
    emit(QuotationLoading());

    final result = await _quotationRepository.updateQuotation(event.quotation);

    result.fold(
      (failure) => emit(QuotationFailure(failure.message)),
      (message) => emit(QuotationSuccess(message: message)),
    );
  }

  void _onPrintQuotation(
      PrintQuotation event, Emitter<QuotationState> emit) async {
    emit(QuotationLoading());

    final result = await _quotationRepository.printQuotation(
      quotation: event.quotation,
      user: event.user,
    );

    result.fold(
      (failure) => emit(QuotationFailure(failure.message)),
      (message) => emit(QuotationSuccess(message: message)),
    );
  }

  void _onQuotationSearch(
      QuotationSearch event, Emitter<QuotationState> emit) async {
    emit(QuotationLoading());

    final result =
        await _quotationRepository.getQuotations(search: event.searchText);

    result.fold(
      (failure) => emit(QuotationFailure(failure.message)),
      (quotations) => emit(QuotationListLoaded(quotations: quotations)),
    );
  }

  void _onDeleteQuotation(
      DeleteQuotation event, Emitter<QuotationState> emit) async {
    emit(QuotationLoading());

    final result = await _quotationRepository.deleteQuotation(event.quotation);

    result.fold(
      (failure) => emit(QuotationFailure(failure.message)),
      (message) => emit(QuotationDeleted(message: message)),
    );
  }

  void _onGetNextQuotationNumber(
      GetNextQuotationNumber event, Emitter<QuotationState> emit) async {
    final result = await _quotationRepository.getNextQuotationNumber();

    result.fold(
      (failure) => emit(QuotationFailure(failure.message)),
      (number) => emit(QuotationNumberGenerated(quotationNumber: number)),
    );
  }
}
