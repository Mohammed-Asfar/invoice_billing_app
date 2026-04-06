import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_billing_app/core/common/widgets/basic_button.dart';
import 'package:invoice_billing_app/core/common/widgets/basic_text_field.dart';
import 'package:invoice_billing_app/core/entities/quotation_controller.dart';
import 'package:invoice_billing_app/core/theme/app_colors.dart';
import 'package:invoice_billing_app/core/theme/app_theme.dart';
import 'package:invoice_billing_app/core/utils/date_format.dart';
import 'package:invoice_billing_app/core/common/widgets/date_field.dart';
import 'package:invoice_billing_app/core/common/widgets/product_field.dart';
import 'package:invoice_billing_app/core/common/widgets/quotation_product_tile.dart';
import 'package:invoice_billing_app/features/quotation/presentation/bloc/quotation_bloc.dart';

class CreateQuotationPage extends StatefulWidget {
  const CreateQuotationPage({super.key});

  @override
  State<CreateQuotationPage> createState() => _CreateQuotationPageState();
}

class _CreateQuotationPageState extends State<CreateQuotationPage> {
  QuotationController? _quotationController;
  bool enableShipping = false;

  _initiateQuotationController() {
    _quotationController = context.read<QuotationBloc>().quotationController;
  }

  @override
  void initState() {
    _initiateQuotationController();
    super.initState();
  }

  void _onReUse() {
    _quotationController!.shippingNameController.text =
        _quotationController!.customerNameController.text;

    _quotationController!.shippingAddressController.text =
        _quotationController!.customerAddressController.text;

    _quotationController!.shippingStateController.text =
        _quotationController!.customerStateNameController.text;

    _quotationController!.shippingCodeController.text =
        _quotationController!.customerCodeController.text;
  }

  void onShipping() {
    setState(() {
      enableShipping = !enableShipping;
    });

    _quotationController!.shippingNameController.text = "";
    _quotationController!.shippingAddressController.text = "";
    _quotationController!.shippingStateController.text = "";
    _quotationController!.shippingCodeController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return _buildQuotationDetails();
  }

  Widget _buildQuotationDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: BasicTextField(
                  // Removed readOnly: true to make quotation number editable
                  controller: _quotationController!.quotationNoController,
                  hintText: "Quotation Number",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DateField(
                  onTap: () async {
                    DateTime? datePicker = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2000, 1, 1),
                      lastDate: DateTime(
                          DateTime.now().year, DateTime.now().month + 1, 0),
                    );
                    setState(() {
                      _quotationController!.issuedDateController = datePicker ??
                          _quotationController!.issuedDateController;
                    });
                  },
                  date: dateFormat(_quotationController!.issuedDateController),
                  hintText: "Issued date",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DateField(
                  onTap: () async {
                    DateTime? datePicker = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );
                    setState(() {
                      _quotationController!.validUntilDateController =
                          datePicker ??
                              _quotationController!.validUntilDateController;
                    });
                  },
                  date: dateFormat(
                      _quotationController!.validUntilDateController),
                  hintText: "Valid until",
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
                  controller: _quotationController!.customerNameController,
                  hintText: "Customer Name",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: BasicTextField(
                  icon: Icons.location_on_rounded,
                  controller: _quotationController!.customerAddressController,
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
                  controller: _quotationController!.customerPhoneController,
                  hintText: "Customer Phone No.",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: BasicTextField(
                  icon: Icons.map_rounded,
                  controller: _quotationController!.customerStateNameController,
                  hintText: "State Name",
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
                  icon: Icons.code_rounded,
                  controller: _quotationController!.customerCodeController,
                  hintText: "Code",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(), // Empty container to maintain layout
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
                                _quotationController!.shippingNameController,
                            hintText: "Name",
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: BasicTextField(
                            icon: Icons.location_on_rounded,
                            controller:
                                _quotationController!.shippingAddressController,
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
                                _quotationController!.shippingStateController,
                            hintText: "State Name",
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: BasicTextField(
                            icon: Icons.code_rounded,
                            controller:
                                _quotationController!.shippingCodeController,
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
                  controller: _quotationController!.subTotalController,
                  hintText: "Sub total",
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Spacer(flex: 4),
              Text("IGST"),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _quotationController!.isIgst =
                        !_quotationController!.isIgst;
                    if (_quotationController!.isIgst) {
                      double sgst = double.tryParse(
                              _quotationController!.sgsttaxController.text) ??
                          0;
                      double cgst = double.tryParse(
                              _quotationController!.cgsttaxController.text) ??
                          0;
                      _quotationController!.igstTaxController.text =
                          (sgst + cgst).toString();
                    }
                    _quotationController!.calculateTotals();
                  });
                },
                child: Icon(
                  _quotationController!.isIgst
                      ? Icons.toggle_on_rounded
                      : Icons.toggle_off_rounded,
                  color: _quotationController!.isIgst
                      ? AppColors.primaryColor
                      : null,
                  size: 50,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          if (_quotationController!.isIgst)
            Row(
              spacing: 20,
              children: [
                Spacer(
                  flex: 4,
                ),
                Text("Output IGST"),
                Expanded(
                  flex: 1,
                  child: ProductField(
                    icon: Icons.percent_rounded,
                    controller: _quotationController!.igstTaxController
                      ..addListener(() {
                        _quotationController!.syncIgstToSgstCgst();
                        _quotationController!.calculateTotals();
                      }),
                    hintText: "IGST Tax",
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ProductField(
                    readOnly: true,
                    icon: Icons.currency_rupee_rounded,
                    controller: _quotationController!.igstAmountController,
                    hintText: "Output IGST",
                  ),
                ),
              ],
            ),
          if (!_quotationController!.isIgst)
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
                    controller: _quotationController!.sgsttaxController
                      ..addListener(() {
                        _quotationController!.calculateTotals();
                      }),
                    hintText: "SGST Tax",
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ProductField(
                    readOnly: true,
                    icon: Icons.currency_rupee_rounded,
                    controller: _quotationController!.sgstController,
                    hintText: "Output SGST",
                  ),
                ),
              ],
            ),
          if (!_quotationController!.isIgst)
            SizedBox(
              height: 10,
            ),
          if (!_quotationController!.isIgst)
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
                    controller: _quotationController!.cgsttaxController
                      ..addListener(() {
                        _quotationController!.calculateTotals();
                      }),
                    hintText: "CGST Tax",
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ProductField(
                    readOnly: true,
                    icon: Icons.currency_rupee_rounded,
                    controller: _quotationController!.cgstController,
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
                  controller: _quotationController!.roundOffController,
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
                  controller: _quotationController!.grandTotalController,
                  hintText: "Grand Total",
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          BasicTextField(
            controller: _quotationController!.grandTotalInWordsController,
            hintText: "Grand Total in Words",
          ),
          const SizedBox(height: 10),
          BasicTextField(
            controller: _quotationController!.termsAndConditionsController,
            hintText: "Terms and Conditions",
            maxLines: 4,
          ),
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
                Expanded(flex: 4, child: Text("Description")),
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
            itemCount: _quotationController!.productControllers.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return QuotationProductTile(
                onSubmitRate: () =>
                    _quotationController!.calculateWithTax(index),
                onSubmitRateWithTax: () =>
                    _quotationController!.calculateWithoutTax(index),
                onPressed: index == 0
                    ? null
                    : () {
                        _quotationController!
                            .removeProductController(index: index);
                        setState(() {});
                      },
                descriptionController:
                    _quotationController!.productControllers[index].description,
                quantityController:
                    _quotationController!.productControllers[index].quantity
                      ..addListener(
                        () {
                          _quotationController!.calculateTotals();
                        },
                      ),
                rateController:
                    _quotationController!.productControllers[index].rate
                      ..addListener(
                        () {
                          _quotationController!.calculateTotals();
                        },
                      ),
                rateWithTaxController:
                    _quotationController!.productControllers[index].rateWithTax
                      ..addListener(
                        () {
                          _quotationController!.calculateTotals();
                        },
                      ),
                perController:
                    _quotationController!.productControllers[index].per,
                totalPriceController:
                    _quotationController!.productControllers[index].totalPrice,
              );
            },
          ),
          TextButton.icon(
            onPressed: () {
              _quotationController!.addProductController();
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
