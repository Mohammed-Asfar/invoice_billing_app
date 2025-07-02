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

  @override
  void initState() {
    super.initState();
    searchBarController = context.read<AppUserCubit>().searchBarController;
    searchBarController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final searchText = searchBarController.text.trim();
      context.read<DashboardBloc>().add(DashboardSearch(searchText));
    });
  }

  @override
  void dispose() {
    searchBarController.removeListener(_onSearchChanged);
    super.dispose();
  }

  void _onSearchChanged() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<DashboardBloc>()
          .add(DashboardSearch(searchBarController.text.trim()));
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
            SizedBox(
              height: 20,
            ),
            BasicTextField(
              icon: Icons.search_rounded,
              islabelNeeded: false,
              controller: searchBarController,
              hintText: "Search by invoice number",
            ),
            SizedBox(height: 20),
            Expanded(
              child: BlocConsumer<DashboardBloc, DashboardState>(
                listener: (context, state) {},
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
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditMainInvoicePage(
                                  invoice: state.invoices[index]),
                            ));
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
}
