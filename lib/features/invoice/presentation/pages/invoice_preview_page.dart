import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_billing_app/core/cubit/app_user/app_user_cubit.dart';
import 'package:invoice_billing_app/core/entities/invoice_controller.dart';
import 'package:invoice_billing_app/features/invoice/presentation/bloc/create_invoice_bloc.dart';
import 'package:invoice_billing_app/core/entities/user.dart';
import 'package:invoice_billing_app/core/theme/app_colors.dart';
import 'package:invoice_billing_app/core/theme/app_theme.dart';
import 'package:invoice_billing_app/core/utils/date_format.dart';
import 'package:invoice_billing_app/core/common/widgets/invoice_detail_header.dart';
import 'package:invoice_billing_app/core/common/widgets/invoice_detail_tile.dart';

class InvoicePreviewPage extends StatefulWidget {
  const InvoicePreviewPage({super.key});

  @override
  State<InvoicePreviewPage> createState() => _InvoicePreviewPageState();
}

class _InvoicePreviewPageState extends State<InvoicePreviewPage> {
  late InvoiceController invoiceController;

  @override
  void initState() {
    invoiceController = context.read<CreateInvoiceBloc>().invoiceController!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = context.read<AppUserCubit>().user;
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        ),
        margin: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          children: [
            Container(
              height: 100,
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppTheme.borderRadius),
                    topRight: Radius.circular(AppTheme.borderRadius)),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor,
                    AppColors.secondaryColor,
                    AppColors.primaryColor,
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
              ),
              child: Center(
                child: Text("Invoice Preview",
                    style: TextStyle(
                        fontSize: 30,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildInvoiceDetails(),
                  SizedBox(height: 20),
                  _billedDetails(user: user),
                  SizedBox(height: 20),
                  _buildProductTable(),
                  SizedBox(height: 20),
                  _buildTotalSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InvoiceDetailTile(
            title: "Invoice No",
            value: invoiceController.invoiceNoController.text),
        SizedBox(
          height: 5,
        ),
        InvoiceDetailTile(
            title: "Invoice Date",
            value: dateFormat(invoiceController.issuedDateController)),
      ],
    );
  }

  Widget _billedDetails({required User user}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        InvoiceDetailHeader(icon: Icons.business, title: "Billed From"),
        SizedBox(
          height: 5,
        ),
        InvoiceDetailTile(
          title: "Name",
          value: user.companyName,
        ),
        InvoiceDetailTile(
          title: "Email",
          value: user.email,
        ),
        InvoiceDetailTile(
          title: "Address",
          value: user.companyAddress,
        ),
        InvoiceDetailTile(
          title: "Phone",
          value: user.mobileNumber,
        ),
        SizedBox(
          height: 20,
        ),
        InvoiceDetailHeader(icon: Icons.assignment, title: "Billed To"),
        SizedBox(
          height: 5,
        ),
        InvoiceDetailTile(
          title: "Name",
          value: invoiceController.customerNameController.text,
        ),
        InvoiceDetailTile(
          title: "Address",
          value: invoiceController.customerAddressController.text,
        ),
        InvoiceDetailTile(
          title: "Phone",
          value: invoiceController.customerPhoneController.text,
        ),
        InvoiceDetailTile(
          title: "GSTIN",
          value: invoiceController.customerGSTINController.text,
        ),
        InvoiceDetailTile(
          title: "State Name",
          value: invoiceController.customerStateNameController.text,
        ),
        InvoiceDetailTile(
          title: "Code",
          value: invoiceController.customerCodeController.text,
        ),
        SizedBox(
          height: 20,
        ),
        InvoiceDetailHeader(
            icon: Icons.local_shipping_rounded, title: "Shipped To"),
        SizedBox(
          height: 5,
        ),
        InvoiceDetailTile(
          title: "Name",
          value: invoiceController.shippingNameController.text,
        ),
        InvoiceDetailTile(
          title: "Address",
          value: invoiceController.shippingAddressController.text,
        ),
        InvoiceDetailTile(
          title: "State Name",
          value: invoiceController.shippingStateController.text,
        ),
        InvoiceDetailTile(
          title: "Code",
          value: invoiceController.shippingCodeController.text,
        ),
      ],
    );
  }

  Widget _buildProductTable() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InvoiceDetailHeader(icon: Icons.table_chart, title: "Products"),
        SizedBox(
          height: 10,
        ),
        Table(
          border: TableBorder.all(
              color: AppColors.fontColor,
              borderRadius: BorderRadius.circular(5)),
          columnWidths: {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(2),
            4: FlexColumnWidth(1),
            5: FlexColumnWidth(2),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(
                  color: AppColors.fontColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5))),
              children: [
                Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("Description",
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("Hsn No",
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("Qty",
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("Rate",
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("Unit",
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("Total",
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
            ...invoiceController.productControllers.map(
              (product) => TableRow(
                children: [
                  Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        product.description.text,
                        style: TextStyle(
                            color: AppColors.fontColor.withValues(alpha: 0.8)),
                      )),
                  Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        product.hsn.text,
                        style: TextStyle(
                            color: AppColors.fontColor.withValues(alpha: 0.8)),
                      )),
                  Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(product.quantity.text,
                          style: TextStyle(
                              color:
                                  AppColors.fontColor.withValues(alpha: 0.8)))),
                  Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(product.rate.text,
                          style: TextStyle(
                              color:
                                  AppColors.fontColor.withValues(alpha: 0.8)))),
                  Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(product.per.text,
                          style: TextStyle(
                              color:
                                  AppColors.fontColor.withValues(alpha: 0.8)))),
                  Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(product.totalPrice.text,
                          style: TextStyle(
                              color:
                                  AppColors.fontColor.withValues(alpha: 0.8)))),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTotalSection() {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InvoiceDetailTile(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            title: "Sub total",
            value: "₹ ${invoiceController.subTotalController.text}"),
        if (invoiceController.isIgst)
          InvoiceDetailTile(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              title: "IGST (${invoiceController.igstTaxController.text}%)",
              value: "₹ ${invoiceController.igstAmountController.text}"),
        if (!invoiceController.isIgst)
          InvoiceDetailTile(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              title: "SGST (${invoiceController.sgsttaxController.text}%)",
              value: "₹ ${invoiceController.sgstController.text}"),
        if (!invoiceController.isIgst)
          InvoiceDetailTile(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              title: "CGST (${invoiceController.cgsttaxController.text}%)",
              value: "₹ ${invoiceController.cgstController.text}"),
        InvoiceDetailTile(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            title: "Round Off",
            value: "₹ ${invoiceController.roundOffController.text}"),
        Divider(),
        InvoiceDetailTile(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            title: "Grand Total",
            value: "₹ ${invoiceController.grandTotalController.text}"),
        InvoiceDetailTile(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            title: "In Words",
            value: invoiceController.grandTotalInWordsController.text),
      ],
    );
  }
}
