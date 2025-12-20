import 'package:flutter/material.dart';
import 'package:invoice_billing_app/core/theme/app_colors.dart';
import 'package:invoice_billing_app/core/common/widgets/product_field.dart';

class QuotationProductTile extends StatefulWidget {
  final TextEditingController descriptionController;
  final TextEditingController quantityController;
  final TextEditingController rateController;
  final TextEditingController rateWithTaxController;
  final TextEditingController perController;
  final TextEditingController totalPriceController;
  final VoidCallback? onPressed;
  final void Function() onSubmitRate;
  final void Function() onSubmitRateWithTax;

  const QuotationProductTile({
    super.key,
    required this.descriptionController,
    required this.quantityController,
    required this.rateController,
    required this.perController,
    required this.totalPriceController,
    this.onPressed,
    required this.rateWithTaxController,
    required this.onSubmitRate,
    required this.onSubmitRateWithTax,
  });

  @override
  State<QuotationProductTile> createState() => _QuotationProductTileState();
}

class _QuotationProductTileState extends State<QuotationProductTile> {
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  // Utility to capitalize text
  void _capitalizeText(TextEditingController controller, String value) {
    if (value.isNotEmpty) {
      final capitalized = value[0].toUpperCase() + value.substring(1);
      // Only update if the text actually changed (first letter capitalization)
      if (controller.text != capitalized) {
        // Preserve the current cursor position
        final currentSelection = controller.selection;
        controller.value = TextEditingValue(
          text: capitalized,
          selection: currentSelection,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Description Field
          Expanded(
            flex: 4,
            child: ProductField(
              onChange: (value) =>
                  _capitalizeText(widget.descriptionController, value),
              icon: Icons.description,
              controller: widget.descriptionController,
              hintText: "Description",
              focusNode: focusNodes[0],
              nextFocusNode: focusNodes[1],
            ),
          ),
          // Quantity Field
          SizedBox(
            width: 50,
            child: ProductField(
              isNumerical: true,
              controller: widget.quantityController,
              hintText: "Qty",
              focusNode: focusNodes[1],
              nextFocusNode: focusNodes[2],
            ),
          ),
          Expanded(
            flex: 2,
            child: ProductField(
              isNumerical: true,
              icon: Icons.currency_rupee_rounded,
              controller: widget.rateController,
              hintText: "Rate",
              onSubmit: widget.onSubmitRate,
              focusNode: focusNodes[2],
              nextFocusNode: focusNodes[3],
            ),
          ),
          // Rate Field
          Expanded(
            flex: 2,
            child: ProductField(
              isNumerical: true,
              icon: Icons.currency_rupee_rounded,
              controller: widget.rateWithTaxController,
              hintText: "Rate Incl tax",
              onSubmit: widget.onSubmitRateWithTax,
              focusNode: focusNodes[3],
              nextFocusNode: focusNodes[4],
            ),
          ),
          // Per Field
          SizedBox(
            width: 50,
            child: ProductField(
              onChange: (value) => _capitalizeText(widget.perController, value),
              controller: widget.perController,
              hintText: "Per",
              focusNode: focusNodes[4],
              nextFocusNode: focusNodes[5],
            ),
          ),
          // Total Price Field
          Expanded(
            flex: 2,
            child: ProductField(
              isNumerical: true,
              readOnly: true,
              icon: Icons.currency_rupee_rounded,
              controller: widget.totalPriceController,
              hintText: "Total Price",
            ),
          ),
          // Delete Button
          widget.onPressed != null
              ? IconButton(
                  onPressed: widget.onPressed,
                  icon: Icon(
                    Icons.delete_rounded,
                    color: AppColors.primaryColor,
                  ),
                )
              : const SizedBox(width: 40),
        ],
      ),
    );
  }
}
