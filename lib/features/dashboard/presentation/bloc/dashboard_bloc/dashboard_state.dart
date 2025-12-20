part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardState {}

final class DashboardInitial extends DashboardState {}

final class DashboardLoading extends DashboardState {}

final class DashboardFailure extends DashboardState {
  final String message;

  DashboardFailure(this.message);
}

final class DashboardSuccess extends DashboardState {
  final List<Invoice> invoices;

  DashboardSuccess({required this.invoices});
}

final class DashboardStatsLoaded extends DashboardState {
  final int totalInvoices;
  final int totalQuotations;
  final int thisMonthInvoices;
  final int thisMonthQuotations;

  DashboardStatsLoaded({
    required this.totalInvoices,
    required this.totalQuotations,
    required this.thisMonthInvoices,
    required this.thisMonthQuotations,
  });
}
