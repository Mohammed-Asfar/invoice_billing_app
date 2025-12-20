import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_billing_app/core/common/widgets/basic_text_field.dart';
import 'package:invoice_billing_app/core/theme/app_colors.dart';
import 'package:invoice_billing_app/core/theme/app_theme.dart';
import 'package:invoice_billing_app/core/utils/date_format.dart';
import 'package:invoice_billing_app/core/utils/loader.dart';
import 'package:invoice_billing_app/features/quotation/presentation/bloc/quotation_bloc.dart';
import 'package:invoice_billing_app/features/quotation/presentation/pages/quotation_page.dart';

class QuotationListPage extends StatefulWidget {
  const QuotationListPage({super.key});

  @override
  State<QuotationListPage> createState() => _QuotationListPageState();
}

class _QuotationListPageState extends State<QuotationListPage> {
  final TextEditingController searchBarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchBarController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final bloc = context.read<QuotationBloc>();
      if (!bloc.isClosed) {
        bloc.add(QuotationSearch(""));
      }
    });
  }

  @override
  void dispose() {
    searchBarController.removeListener(_onSearchChanged);
    searchBarController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final bloc = context.read<QuotationBloc>();
      if (!bloc.isClosed) {
        bloc.add(QuotationSearch(searchBarController.text.trim()));
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
            Row(
              children: [
                Expanded(
                  child: BasicTextField(
                    icon: Icons.search_rounded,
                    islabelNeeded: false,
                    controller: searchBarController,
                    hintText: "Search by quotation number or customer name",
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: BlocConsumer<QuotationBloc, QuotationState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is QuotationLoading) {
                    return Loader();
                  }
                  if (state is QuotationFailure) {
                    return Align(
                      alignment: Alignment.center,
                      child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  if (state is QuotationListLoaded) {
                    if (state.quotations.isEmpty) {
                      return Center(
                        child: Text(
                          "No quotations found",
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: state.quotations.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final quotation = state.quotations[index];
                        if (quotation == null) return SizedBox.shrink();
                        return ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onTap: () async {
                            // Capture bloc reference before navigation
                            final bloc = context.read<QuotationBloc>();
                            final searchText = searchBarController.text.trim();

                            await Navigator.of(context)
                                .push(QuotationPage.editRoute(quotation));
                            // Refresh list after returning from edit page
                            if (!mounted) return;
                            if (!bloc.isClosed) {
                              bloc.add(QuotationSearch(searchText));
                            }
                          },
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: AppColors.selectedFontColor,
                            child: Icon(Icons.description_rounded),
                          ),
                          title: Text(
                            quotation.quotationNumber,
                            style: TextStyle(fontSize: 14),
                          ),
                          subtitle: Text(
                            "${quotation.customerName} • ${dateFormat(quotation.issuedDate)}",
                            style: TextStyle(fontSize: 12),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "₹${quotation.grandTotal.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.arrow_forward_ios_rounded),
                            ],
                          ),
                        );
                      },
                    );
                  }
                  return Center(
                    child: Text(
                      "No quotations found",
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
