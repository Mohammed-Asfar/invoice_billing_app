part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardEvent {}

final class DashboardSearch extends DashboardEvent {
  final String searchText;

  DashboardSearch(this.searchText);
}
