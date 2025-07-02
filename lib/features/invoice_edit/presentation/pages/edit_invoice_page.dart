import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_billing_app/core/common/widgets/basic_button.dart';
import 'package:invoice_billing_app/core/common/widgets/basic_text_field.dart';
import 'package:invoice_billing_app/core/entities/invoice_controller.dart';
import 'package:invoice_billing_app/core/theme/app_colors.dart';
import 'package:invoice_billing_app/core/theme/app_theme.dart';
import 'package:invoice_billing_app/core/utils/date_format.dart';
import 'package:invoice_billing_app/core/common/widgets/date_field.dart';
import 'package:invoice_billing_app/core/common/widgets/product_field.dart';
import 'package:invoice_billing_app/core/common/widgets/product_tile.dart';
import 'package:invoice_billing_app/features/invoice_edit/presentation/bloc/edit_invoice_bloc.dart';

class EditInvoicePage extends StatefulWidget {
  const EditInvoicePage({super.key});

  @override
  State<EditInvoicePage> createState() => _EditInvoicePageState();
}

class _EditInvoicePageState extends State<EditInvoicePage> {
  InvoiceController? _invoiceController;
  bool enableShipping = false;

  @override
  void initState() {
    _invoiceController = context.read<EditInvoiceBloc>().invoiceController;
    if (_invoiceController!.shippingNameController.text != "") {
      enableShipping = !enableShipping;
    }
    super.initState();
  }

  void _onReUse() {
    _invoiceController!.shippingNameController.text =
        _invoiceController!.customerNameController.text;

    _invoiceController!.shippingAddressController.text =
        _invoiceController!.customerAddressController.text;

    _invoiceController!.shippingStateController.text =
        _invoiceController!.customerStateNameController.text;

    _invoiceController!.shippingCodeController.text =
        _invoiceController!.customerCodeController.text;
  }

  void onShipping() {
    setState(() {
      enableShipping = !enableShipping;
    });

    _invoiceController!.shippingNameController.text = "";
    _invoiceController!.shippingAddressController.text = "";
    _invoiceController!.shippingStateController.text = "";
    _invoiceController!.shippingCodeController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return _buildInvoiceDetails();
  }

  Widget _buildInvoiceDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: BasicTextField(
                  readOnly: true,
                  controller: _invoiceController!.invoiceNoController,
                  hintText: "Invoice Number",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DateField(
                  onTap: () async {
                    DateTime? datePicker = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    setState(() {
                      _invoiceController!.issuedDateController = datePicker ??
                          _invoiceController!.issuedDateController;
                    });
                  },
                  date: dateFormat(_invoiceController!.issuedDateController),
                  hintText: "Issued date",
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "Customer details",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppColors.fontColor,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: BasicTextField(
                  icon: Icons.person,
                  controller: _invoiceController!.customerNameController,
                  hintText: "Customer Name",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: BasicTextField(
                  icon: Icons.location_on_rounded,
                  controller: _invoiceController!.customerAddressController,
                  hintText: "Customer Address",
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: BasicTextField(
                  icon: Icons.phone_rounded,
                  controller: _invoiceController!.customerPhoneController,
                  hintText: "Customer Phone No.",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: BasicTextField(
                  icon: Icons.confirmation_number_rounded,
                  controller: _invoiceController!.customerGSTINController,
                  hintText: "Customer GSTIN",
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: BasicTextField(
                  icon: Icons.map_rounded,
                  controller: _invoiceController!.customerStateNameController,
                  hintText: "State Name",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: BasicTextField(
                  icon: Icons.code_rounded,
                  controller: _invoiceController!.customerCodeController,
                  hintText: "Code",
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(
                "Shipping details",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColors.fontColor,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () => onShipping(),
                child: Icon(
                  enableShipping
                      ? Icons.toggle_on_rounded
                      : Icons.toggle_off_rounded,
                  color: enableShipping ? AppColors.primaryColor : null,
                  size: 50,
                ),
              ),
              Spacer(),
              !enableShipping
                  ? Container()
                  : BasicButton(
                      width: 150, text: "Reuse details", onPressed: _onReUse)
            ],
          ),
          !enableShipping
              ? Container()
              : Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: BasicTextField(
                            icon: Icons.person,
                            controller:
                                _invoiceController!.shippingNameController,
                            hintText: "Name",
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: BasicTextField(
                            icon: Icons.location_on_rounded,
                            controller:
                                _invoiceController!.shippingAddressController,
                            hintText: "Address",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: BasicTextField(
                            icon: Icons.map_rounded,
                            controller:
                                _invoiceController!.shippingStateController,
                            hintText: "State Name",
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: BasicTextField(
                            icon: Icons.code_rounded,
                            controller:
                                _invoiceController!.shippingCodeController,
                            hintText: "Code",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
          const SizedBox(height: 20),
          Text(
            "Product details",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppColors.fontColor,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          _productList(),
          SizedBox(
            height: 20,
          ),
          Row(
            spacing: 20,
            children: [
              Spacer(
                flex: 4,
              ),
              Text("Sub total"),
              Spacer(
                flex: 1,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 2,
                child: ProductField(
                  readOnly: true,
                  icon: Icons.currency_rupee_rounded,
                  controller: _invoiceController!.subTotalController,
                  hintText: "Sub total",
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            spacing: 20,
            children: [
              Spacer(
                flex: 4,
              ),
              Text("Output SGST"),
              Expanded(
                flex: 1,
                child: ProductField(
                  icon: Icons.percent_rounded,
                  controller: _invoiceController!.sgsttaxController
                    ..addListener(() {
                      _invoiceController!.calculateTotals();
                    }),
                  hintText: "SGST Tax",
                ),
              ),
              Expanded(
                flex: 2,
                child: ProductField(
                  readOnly: true,
                  icon: Icons.currency_rupee_rounded,
                  controller: _invoiceController!.sgstController,
                  hintText: "Output SGST",
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            spacing: 20,
            children: [
              Spacer(
                flex: 4,
              ),
              Text("Output CGST"),
              Expanded(
                flex: 1,
                child: ProductField(
                  icon: Icons.percent_rounded,
                  controller: _invoiceController!.cgsttaxController
                    ..addListener(() {
                      _invoiceController!.calculateTotals();
                    }),
                  hintText: "CGST Tax",
                ),
              ),
              Expanded(
                flex: 2,
                child: ProductField(
                  readOnly: true,
                  icon: Icons.currency_rupee_rounded,
                  controller: _invoiceController!.cgstController,
                  hintText: "Output CGST",
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            spacing: 20,
            children: [
              Spacer(
                flex: 4,
              ),
              Text("Round off     "),
              Spacer(
                flex: 1,
              ),
              Expanded(
                flex: 2,
                child: ProductField(
                  readOnly: true,
                  icon: Icons.currency_rupee_rounded,
                  controller: _invoiceController!.roundOffController,
                  hintText: "Round off",
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            spacing: 20,
            children: [
              Spacer(
                flex: 4,
              ),
              Text("Grand Total"),
              Spacer(
                flex: 1,
              ),
              Expanded(
                flex: 2,
                child: ProductField(
                  readOnly: true,
                  icon: Icons.currency_rupee_rounded,
                  controller: _invoiceController!.grandTotalController,
                  hintText: "Grand Total",
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          BasicTextField(
            controller: _invoiceController!.grandTotalInWordsController,
            hintText: "Grand Total in Words",
          )
        ],
      ),
    );
  }

  Widget _productList() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        border: Border.all(color: AppColors.primaryColor, width: 2),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppTheme.borderRadius - 2),
                topRight: Radius.circular(AppTheme.borderRadius - 2),
              ),
            ),
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              spacing: 10,
              children: const [
                Expanded(flex: 3, child: Text("Description")),
                Expanded(flex: 2, child: Text("HSN No")),
                Expanded(flex: 1, child: Text("Qty")),
                Expanded(flex: 2, child: Text("Rate")),
                Expanded(flex: 2, child: Text("Rate Incl. tax")),
                Expanded(flex: 1, child: Text("Per")),
                Expanded(flex: 2, child: Text("Total Price")),
                SizedBox(
                  width: 35,
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            itemCount: _invoiceController!.productControllers.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ProductTile(
                onSubmitRate: () => _invoiceController!.calculateWithTax(index),
                onSubmitRateWithTax: () =>
                    _invoiceController!.calculateWithoutTax(index),
                onPressed: index == 0
                    ? null
                    : () {
                        _invoiceController!
                            .removeProductController(index: index);
                        setState(() {});
                      },
                descriptionController:
                    _invoiceController!.productControllers[index].description,
                hsnController:
                    _invoiceController!.productControllers[index].hsn,
                quantityController:
                    _invoiceController!.productControllers[index].quantity
                      ..addListener(
                        () {
                          _invoiceController!.calculateTotals();
                        },
                      ),
                rateController:
                    _invoiceController!.productControllers[index].rate
                      ..addListener(
                        () {
                          _invoiceController!.calculateTotals();
                        },
                      ),
                rateWithTaxController:
                    _invoiceController!.productControllers[index].rateWithTax
                      ..addListener(
                        () {
                          _invoiceController!.calculateTotals();
                        },
                      ),
                perController:
                    _invoiceController!.productControllers[index].per,
                totalPriceController:
                    _invoiceController!.productControllers[index].totalPrice,
              );
            },
          ),
          TextButton.icon(
            onPressed: () {
              _invoiceController!.addProductController();
              setState(() {});
            },
            label: Text(
              "Add a line item",
              style: TextStyle(color: AppColors.primaryColor),
            ),
            icon: Icon(
              Icons.add_circle_rounded,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
