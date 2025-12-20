import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_billing_app/core/common/widgets/basic_text_field.dart';
import 'package:invoice_billing_app/core/cubit/app_user/app_user_cubit.dart';
import 'package:invoice_billing_app/core/theme/app_colors.dart';
import 'package:invoice_billing_app/core/theme/app_theme.dart';
import 'package:invoice_billing_app/core/utils/loader.dart';
import 'package:invoice_billing_app/features/dashboard/presentation/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:invoice_billing_app/features/invoice_edit/presentation/pages/edit_main_invoice_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late TextEditingController searchBarController;

  // Stats data
  int totalInvoices = 0;
  int totalQuotations = 0;
  int thisMonthInvoices = 0;
  int thisMonthQuotations = 0;

  @override
  void initState() {
    super.initState();
    searchBarController = context.read<AppUserCubit>().searchBarController;
    searchBarController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final searchText = searchBarController.text.trim();
      final bloc = context.read<DashboardBloc>();
      if (!bloc.isClosed) {
        bloc.add(DashboardSearch(searchText));
        bloc.add(FetchDashboardStats());
      }
    });
  }

  @override
  void dispose() {
    searchBarController.removeListener(_onSearchChanged);
    super.dispose();
  }

  void _onSearchChanged() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final bloc = context.read<DashboardBloc>();
      if (!bloc.isClosed) {
        bloc.add(DashboardSearch(searchBarController.text.trim()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withAlpha(40),
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        ),
        margin: const EdgeInsets.only(
          top: 30,
          bottom: 10,
          right: 10,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20),
            // Statistics Cards Row
            BlocListener<DashboardBloc, DashboardState>(
              listener: (context, state) {
                if (state is DashboardStatsLoaded) {
                  setState(() {
                    totalInvoices = state.totalInvoices;
                    totalQuotations = state.totalQuotations;
                    thisMonthInvoices = state.thisMonthInvoices;
                    thisMonthQuotations = state.thisMonthQuotations;
                  });
                }
              },
              child: Row(
                children: [
                  _buildStatCard(
                    icon: Icons.receipt_long_rounded,
                    value: totalInvoices.toString(),
                    label: 'Total Invoices',
                    color: AppColors.secondaryColor,
                  ),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    icon: Icons.description_rounded,
                    value: totalQuotations.toString(),
                    label: 'Total Quotations',
                    color: AppColors.secondaryColor,
                  ),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    icon: Icons.calendar_today_rounded,
                    value: thisMonthInvoices.toString(),
                    label: 'Invoices This Month',
                    color: AppColors.secondaryColor,
                  ),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    icon: Icons.event_note_rounded,
                    value: thisMonthQuotations.toString(),
                    label: 'Quotations This Month',
                    color: AppColors.secondaryColor,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            BasicTextField(
              icon: Icons.search_rounded,
              islabelNeeded: false,
              controller: searchBarController,
              hintText: "Search by invoice number",
            ),
            SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<DashboardBloc, DashboardState>(
                buildWhen: (previous, current) =>
                    current is DashboardLoading ||
                    current is DashboardSuccess ||
                    current is DashboardFailure,
                builder: (context, state) {
                  if (state is DashboardLoading) {
                    return Loader();
                  }
                  if (state is DashboardFailure) {
                    return Align(
                      alignment: Alignment.center,
                      child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  if (state is DashboardSuccess) {
                    return ListView.builder(
                      itemCount: state.invoices.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onTap: () async {
                            final bloc = context.read<DashboardBloc>();
                            await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditMainInvoicePage(
                                  invoice: state.invoices[index]),
                            ));
                            // Refresh stats after returning
                            if (!mounted) return;
                            if (!bloc.isClosed) {
                              bloc.add(FetchDashboardStats());
                            }
                          },
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: AppColors.selectedFontColor,
                            child: Icon(Icons.assignment_rounded),
                          ),
                          title: Text(
                            state.invoices[index].invoiceNumber,
                            style: TextStyle(fontSize: 14),
                          ),
                          subtitle: Text(state.invoices[index].customerName,
                              style: TextStyle(fontSize: 12)),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                          ),
                        );
                      },
                    );
                  }
                  return Center(
                      child: Text(
                    "No invoices found",
                    textAlign: TextAlign.center,
                  ));
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withAlpha(30),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(60), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withAlpha(50),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.fontColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
