import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_billing_app/core/common/widgets/basic_button.dart';
import 'package:invoice_billing_app/core/common/widgets/basic_text_field.dart';
import 'package:invoice_billing_app/core/common/widgets/date_field.dart';
import 'package:invoice_billing_app/core/common/widgets/product_field.dart';
import 'package:invoice_billing_app/core/common/widgets/quotation_product_tile.dart';
import 'package:invoice_billing_app/core/cubit/app_user/app_user_cubit.dart';
import 'package:invoice_billing_app/core/entities/quotation_controller.dart';
import 'package:invoice_billing_app/core/theme/app_colors.dart';
import 'package:invoice_billing_app/core/theme/app_theme.dart';
import 'package:invoice_billing_app/core/utils/date_format.dart';
import 'package:invoice_billing_app/core/utils/show_app_dialog.dart';
import 'package:invoice_billing_app/core/utils/show_snackbar.dart';
import 'package:invoice_billing_app/features/quotation_edit/presentation/bloc/edit_quotation_bloc.dart';

class EditQuotationPage extends StatefulWidget {
  const EditQuotationPage({super.key});

  static route() => CupertinoPageRoute(
        builder: (context) => const EditQuotationPage(),
      );

  @override
  State<EditQuotationPage> createState() => _EditQuotationPageState();
}

class _EditQuotationPageState extends State<EditQuotationPage> {
  QuotationController? _quotationController;
  bool enableShipping = false;

  @override
  void initState() {
    _quotationController =
        context.read<EditQuotationBloc>().quotationController;
    if (_quotationController!.shippingNameController.text != "") {
      enableShipping = true;
    }
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

  void _onDelete() {
    showAppDialog(
      context: context,
      title: "Delete Quotation",
      text: "Are you sure you want to delete this quotation?",
      onPressed: () {
        Navigator.of(context).pop();
        context.read<EditQuotationBloc>().add(
              EditQuotationDelete(
                quotation: _quotationController!.toQuotationModel(),
              ),
            );
      },
    );
  }

  void _onUpdate() {
    context.read<EditQuotationBloc>().add(
          EditQuotationUpdate(
            quotation: _quotationController!.toQuotationModel(),
          ),
        );
  }

  void _onPrint() {
    final user = context.read<AppUserCubit>().user;
    context.read<EditQuotationBloc>().add(
          EditQuotationPrint(
            quotation: _quotationController!.toQuotationModel(),
            user: user,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditQuotationBloc, EditQuotationState>(
      listener: (context, state) {
        if (state is EditQuotationSuccess) {
          showSnackBar(context: context, text: state.message);
          if (state.isDeleted || state.isUpdated) {
            Navigator.of(context).pop();
          }
        }
        if (state is EditQuotationFailure) {
          showSnackBar(context: context, text: state.message);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withAlpha(40),
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          ),
          margin: const EdgeInsets.only(top: 30, bottom: 10, right: 10),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              ListTile(
                leading: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
                title: Text(
                  "Edit Quotation",
                  style: const TextStyle(fontSize: 25),
                ),
                trailing: BlocBuilder<EditQuotationBloc, EditQuotationState>(
                  builder: (context, state) {
                    final isLoading = state is EditQuotationLoading;
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BasicButton(
                          color: Colors.red,
                          width: 100,
                          text: "Delete",
                          onPressed: isLoading ? () {} : _onDelete,
                        ),
                        const SizedBox(width: 10),
                        BasicButton(
                          color: AppColors.secondaryColor,
                          width: 100,
                          text: "Print",
                          onPressed: isLoading ? () {} : _onPrint,
                        ),
                        const SizedBox(width: 10),
                        BasicButton(
                          color: AppColors.primaryColor,
                          width: isLoading ? 130 : 100,
                          text: isLoading ? "Updating..." : "Update",
                          onPressed: isLoading ? () {} : _onUpdate,
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _buildQuotationDetails(),
              ),
            ],
          ),
        ),
      ),
    );
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
                  readOnly: true,
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
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
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
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
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
          const SizedBox(height: 20),
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
          const SizedBox(height: 20),
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
              const Expanded(child: SizedBox()),
            ],
          ),
          const SizedBox(height: 20),
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
              const SizedBox(width: 10),
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
              const Spacer(),
              if (enableShipping)
                BasicButton(
                    width: 150, text: "Reuse details", onPressed: _onReUse),
            ],
          ),
          if (enableShipping)
            Column(
              children: [
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
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
          const SizedBox(height: 20),
          _productList(),
          const SizedBox(height: 20),
          _buildTotalSection(),
          const SizedBox(height: 20),
          BasicTextField(
            controller: _quotationController!.termsAndConditionsController,
            hintText: "Terms and Conditions",
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSection() {
    return Column(
      children: [
        Row(
          children: [
            const Spacer(flex: 4),
            const Text("Sub total"),
            const Spacer(flex: 1),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: ProductField(
                readOnly: true,
                icon: Icons.currency_rupee_rounded,
                controller: _quotationController!.subTotalController,
                hintText: "Sub total",
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Spacer(flex: 4),
            const Text("Output SGST"),
            Expanded(
              flex: 1,
              child: ProductField(
                icon: Icons.percent_rounded,
                controller: _quotationController!.sgsttaxController
                  ..addListener(() => _quotationController!.calculateTotals()),
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
        const SizedBox(height: 10),
        Row(
          children: [
            const Spacer(flex: 4),
            const Text("Output CGST"),
            Expanded(
              flex: 1,
              child: ProductField(
                icon: Icons.percent_rounded,
                controller: _quotationController!.cgsttaxController
                  ..addListener(() => _quotationController!.calculateTotals()),
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
        const SizedBox(height: 10),
        Row(
          children: [
            const Spacer(flex: 4),
            const Text("Round off     "),
            const Spacer(flex: 1),
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
        const SizedBox(height: 10),
        Row(
          children: [
            const Spacer(flex: 4),
            const Text("Grand Total"),
            const Spacer(flex: 1),
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
        const SizedBox(height: 10),
        BasicTextField(
          controller: _quotationController!.grandTotalInWordsController,
          hintText: "Grand Total in Words",
        ),
      ],
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
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(flex: 3, child: Text("Description")),
                Expanded(flex: 1, child: Text("Qty")),
                Expanded(flex: 2, child: Text("Rate")),
                Expanded(flex: 2, child: Text("Rate Incl. tax")),
                Expanded(flex: 1, child: Text("Per")),
                Expanded(flex: 2, child: Text("Total Price")),
                SizedBox(width: 35),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            itemCount: _quotationController!.productControllers.length,
            physics: const NeverScrollableScrollPhysics(),
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
                quantityController: _quotationController!
                    .productControllers[index].quantity
                  ..addListener(() => _quotationController!.calculateTotals()),
                rateController: _quotationController!
                    .productControllers[index].rate
                  ..addListener(() => _quotationController!.calculateTotals()),
                rateWithTaxController: _quotationController!
                    .productControllers[index].rateWithTax
                  ..addListener(() => _quotationController!.calculateTotals()),
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
            icon: Icon(Icons.add_circle_rounded, color: AppColors.primaryColor),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
