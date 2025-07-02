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
