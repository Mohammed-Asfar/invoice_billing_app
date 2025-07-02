import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_billing_app/core/common/widgets/basic_button.dart';
import 'package:invoice_billing_app/core/cubit/app_user/app_user_cubit.dart';
import 'package:invoice_billing_app/core/entities/invoice_controller.dart';
import 'package:invoice_billing_app/core/theme/app_colors.dart';
import 'package:invoice_billing_app/core/theme/app_theme.dart';
import 'package:invoice_billing_app/core/utils/loader.dart';
import 'package:invoice_billing_app/core/utils/show_snackbar.dart';
import 'package:invoice_billing_app/features/invoice/presentation/bloc/create_invoice_bloc.dart';
import 'package:invoice_billing_app/features/invoice/presentation/pages/create_invoice_page.dart';
import 'package:invoice_billing_app/features/invoice/presentation/pages/invoice_preview_page.dart';
import 'package:invoice_billing_app/core/common/widgets/highlight_button.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  int selectedStep = 0;
  final List<String> title = ["Create Invoice", "Preview Invoice"];
  final List<String> buttonTitle = ["Preview", "Generate Invoice"];
  final PageController pageController = PageController();
  final formKey = GlobalKey<FormState>();

  void _movePage({required int pageInt}) {
    if (formKey.currentState!.validate()) {
      setState(() {
        selectedStep = pageInt;
      });
      pageController.animateToPage(pageInt,
          duration: Duration(milliseconds: 300), curve: Curves.linear);
    }
  }

  _initiateInvoiceController() {
    if (context.read<AppUserCubit>().invoiceController == null) {
      context.read<AppUserCubit>().invoiceController = InvoiceController();
      context
          .read<AppUserCubit>()
          .invoiceController!
          .customerStateNameController
          .text = "TAMIL NADU";
      context
          .read<AppUserCubit>()
          .invoiceController!
          .customerCodeController
          .text = "33";
    }
  }

  @override
  void initState() {
    _initiateInvoiceController();
    context.read<CreateInvoiceBloc>().add(CreateInvoiceGetInvoiceNo());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocConsumer<CreateInvoiceBloc, CreateInvoiceState>(
        listener: (context, state) {
          if (state is CreateInvoiceFailure) {
            showSnackBar(context: context, text: state.message);
          }
          if (state is CreateInvoiceSuccess) {
            if (state.message != "") {
              context
                  .read<CreateInvoiceBloc>()
                  .add(CreateInvoiceGetInvoiceNo());
              showSnackBar(context: context, text: state.message);
            }
          }
        },
        builder: (context, state) {
          if (state is CreateInvoiceLoading) {
            return Loader();
          }
          return Container(
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
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: selectedStep == 1
                        ? IconButton(
                            onPressed: () {
                              _movePage(pageInt: 0);
                            },
                            icon: Icon(Icons.arrow_back_ios_new_rounded))
                        : null,
                    title: Text(
                      title[selectedStep],
                      style: const TextStyle(fontSize: 25),
                      textAlign: TextAlign.start,
                    ),
                    trailing: BasicButton(
                        color: AppColors.primaryColor,
                        width: selectedStep == 0 ? 150 : 200,
                        text: buttonTitle[selectedStep],
                        onPressed: () {
                          if (selectedStep == 0) {
                            _movePage(pageInt: 1);
                          } else {
                            _movePage(pageInt: 0);
                            final invoiceController =
                                context.read<AppUserCubit>().invoiceController;
                            context.read<CreateInvoiceBloc>().add(CreateInvoice(
                                invoice: invoiceController!.toInvoiceModel(),
                                user: context.read<AppUserCubit>().user));
                          }
                        }),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      HighlightButton(
                        isSelected: selectedStep == 0,
                        onTap: () {
                          _movePage(pageInt: 0);
                        },
                        step: "1",
                        title: "Details",
                        description: "Enter Invoice details",
                      ),
                      Expanded(
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      HighlightButton(
                        isSelected: selectedStep == 1,
                        onTap: () {
                          _movePage(pageInt: 1);
                        },
                        step: "2",
                        title: "Preview",
                        description: "Preview and Print Invoice",
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                      child: PageView(
                    controller: pageController,
                    children: [
                      CreateInvoicePage(),
                      InvoicePreviewPage(),
                    ],
                  )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
