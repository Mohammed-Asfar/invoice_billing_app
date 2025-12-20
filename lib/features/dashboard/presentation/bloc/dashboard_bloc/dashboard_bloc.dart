import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_billing_app/core/entities/invoice.dart';
import 'package:invoice_billing_app/features/dashboard/domain/repository/dashboard_repository.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _dashboardRepository;

  DashboardBloc({required DashboardRepository dashboardRepository})
      : _dashboardRepository = dashboardRepository,
        super(DashboardInitial()) {
    on<DashboardSearch>(_onDashboardSearch);
    on<FetchDashboardStats>(_onFetchDashboardStats);
  }

  void _onDashboardSearch(
      DashboardSearch event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());

    final result =
        await _dashboardRepository.getInvoices(search: event.searchText);

    result.fold(
      (failure) => emit(DashboardFailure(failure.message)),
      (invoices) => emit(DashboardSuccess(invoices: invoices)),
    );
  }

  void _onFetchDashboardStats(
      FetchDashboardStats event, Emitter<DashboardState> emit) async {
    final result = await _dashboardRepository.getStats();

    result.fold(
      (failure) => emit(DashboardFailure(failure.message)),
      (stats) => emit(DashboardStatsLoaded(
        totalInvoices: stats['totalInvoices'] ?? 0,
        totalQuotations: stats['totalQuotations'] ?? 0,
        thisMonthInvoices: stats['thisMonthInvoices'] ?? 0,
        thisMonthQuotations: stats['thisMonthQuotations'] ?? 0,
      )),
    );
  }
}
