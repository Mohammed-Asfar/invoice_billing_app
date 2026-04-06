import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_billing_app/core/cubit/app_user/app_user_cubit.dart';
import 'package:invoice_billing_app/core/entities/invoice.dart';
import 'package:invoice_billing_app/core/entities/invoice_controller.dart';
import 'package:invoice_billing_app/core/entities/productController.dart';
import 'package:invoice_billing_app/core/theme/app_colors.dart';
import 'package:invoice_billing_app/core/theme/app_theme.dart';
import 'package:invoice_billing_app/core/utils/loader.dart';
import 'package:invoice_billing_app/core/utils/show_snackbar.dart';
import 'package:invoice_billing_app/core/common/widgets/highlight_button.dart';
import 'package:invoice_billing_app/features/dashboard/presentation/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:invoice_billing_app/features/invoice_edit/presentation/bloc/edit_invoice_bloc.dart';
import 'package:invoice_billing_app/features/invoice_edit/presentation/pages/edit_invoice_page.dart';
import 'package:invoice_billing_app/features/invoice_edit/presentation/pages/edit_invoice_preview_page.dart';
import 'package:invoice_billing_app/features/invoice_edit/presentation/widgets/edit_page_header.dart';
import 'package:invoice_billing_app/main.dart';

class EditMainInvoicePage extends StatefulWidget {
  final Invoice invoice;
  const EditMainInvoicePage({super.key, required this.invoice});

  @override
  State<EditMainInvoicePage> createState() => _EditMainInvoicePageState();
}

class _EditMainInvoicePageState extends State<EditMainInvoicePage> {
  int selectedStep = 0;
  final List<String> title = ["Edit Invoice", "Preview Invoice"];
  final List<String> buttonTitle = ["Preview", "Update Invoice"];
  final PageController pageController = PageController();
  final formKey = GlobalKey<FormState>();
  late InvoiceController invoiceController;

  void _movePage({required int pageInt}) {
    if (formKey.currentState!.validate()) {
      setState(() {
        selectedStep = pageInt;
      });
      pageController.animateToPage(pageInt,
          duration: Duration(milliseconds: 300), curve: Curves.linear);
    }
  }

  _onPressed() {
    if (selectedStep == 0) {
      _movePage(pageInt: 1);
    } else {
      context.read<EditInvoiceBloc>().add(EditInvoiceUpdate(
          invoice: invoiceController.toInvoiceModel(),
          user: context.read<AppUserCubit>().user));
    }
  }

  _initialize() {
    invoiceController = InvoiceController();
    invoiceController.customerNameController.text = widget.invoice.customerName;
    invoiceController.customerPhoneController.text =
        widget.invoice.customerPhone;
    invoiceController.customerGSTINController.text =
        widget.invoice.customerGSTIN;
    invoiceController.customerAddressController.text =
        widget.invoice.customerAddress;
    invoiceController.issuedDateController = widget.invoice.issuedDate;
    invoiceController.productControllers = widget.invoice.products
        .map((e) => Productcontroller(
            rateWithTax: TextEditingController(text: e.rateWithTax.toString()),
            description: TextEditingController(text: e.description),
            quantity: TextEditingController(text: e.quantity.toString()),
            rate: TextEditingController(text: e.rate.toString()),
            per: TextEditingController(text: e.per),
            totalPrice: TextEditingController(text: e.totalPrice.toString()),
            hsn: TextEditingController(text: e.hsn.toString())))
        .toList();
    invoiceController.subTotalController.text =
        widget.invoice.subTotal.toString();
    invoiceController.sgsttaxController.text =
        widget.invoice.sgstPercent.toString();
    invoiceController.cgsttaxController.text =
        widget.invoice.cgstPercent.toString();
    invoiceController.sgstController.text =
        widget.invoice.sgstAmount.toString();
    invoiceController.cgstController.text =
        widget.invoice.cgstAmount.toString();
    invoiceController.roundOffController.text =
        widget.invoice.roundOff.toString();
    invoiceController.grandTotalController.text =
        widget.invoice.grandTotal.toString();
    invoiceController.grandTotalInWordsController.text =
        widget.invoice.grandTotalInWords;
    invoiceController.invoiceNoController.text = widget.invoice.invoiceNumber;
    invoiceController.shippingAddressController.text =
        widget.invoice.shippingAddress;
    invoiceController.shippingCodeController.text = widget.invoice.shippingCode;
    invoiceController.shippingNameController.text = widget.invoice.shippingName;
    invoiceController.shippingStateController.text =
        widget.invoice.shippingState;
    invoiceController.customerCodeController.text = widget.invoice.customerCode;
    invoiceController.customerStateNameController.text =
        widget.invoice.customerStateName;
    invoiceController.isIgst = widget.invoice.isIgst;
    if (widget.invoice.isIgst) {
      invoiceController.igstTaxController.text =
          (widget.invoice.sgstPercent + widget.invoice.cgstPercent).toString();
      invoiceController.igstAmountController.text =
          (widget.invoice.sgstAmount + widget.invoice.cgstAmount).toString();
    }

    context.read<EditInvoiceBloc>().invoiceController = invoiceController;
  }

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WindowTitleBar(
      child: Scaffold(
        body: Container(
          decoration: AppTheme.backgroundColor2Theme,
          child: BlocConsumer<EditInvoiceBloc, EditInvoiceState>(
            listener: (context, state) {
              if (state is EditInvoiceFailure) {
                showSnackBar(context: context, text: state.message);
              }
              if (state is EditInvoiceSuccess) {
                if (state.message != "" && !state.isDialogOpen) {
                  showSnackBar(context: context, text: state.message);
                } else if (state.isDialogOpen) {
                  showSnackBar(context: context, text: state.message);
                  context.read<DashboardBloc>().add(DashboardSearch(""));
                  Navigator.of(context).pop();
                }
              }
            },
            builder: (context, state) {
              if (state is EditInvoiceLoading) {
                return Loader();
              }
              return Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 10,
                  right: 10,
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EditPageHeader(
                          selectedStep: selectedStep,
                          title: title[selectedStep],
                          deleteOnPressed: () {
                            context
                                .read<EditInvoiceBloc>()
                                .add(EditInvoiceDelete(
                                  invoice: widget.invoice,
                                ));
                          },
                          printOnPressed: () {
                            context.read<EditInvoiceBloc>().add(
                                EditInvoicePrint(
                                    invoice: widget.invoice,
                                    user: context.read<AppUserCubit>().user));
                            _movePage(pageInt: 0);
                          },
                          onPressed: _onPressed,
                          buttonText: buttonTitle[selectedStep],
                          iconPressed: () {
                            if (selectedStep == 0) {
                              Navigator.pop(context);
                            } else {
                              _movePage(pageInt: 0);
                            }
                          }),
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
                            description: "Edit Invoice details",
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
                          EditInvoicePage(),
                          EditInvoicePreviewPage(),
                        ],
                      )),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
