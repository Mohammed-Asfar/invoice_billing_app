import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_billing_app/core/common/widgets/basic_button.dart';
import 'package:invoice_billing_app/core/cubit/app_user/app_user_cubit.dart';
import 'package:invoice_billing_app/core/entities/quotation.dart';
import 'package:invoice_billing_app/core/entities/quotation_controller.dart';
import 'package:invoice_billing_app/core/theme/app_colors.dart';
import 'package:invoice_billing_app/core/theme/app_theme.dart';
import 'package:invoice_billing_app/core/utils/show_app_dialog.dart';
import 'package:invoice_billing_app/core/utils/show_snackbar.dart';
import 'package:invoice_billing_app/features/quotation/presentation/bloc/quotation_bloc.dart';
import 'package:invoice_billing_app/features/quotation/presentation/pages/create_quotation_page.dart';
import 'package:invoice_billing_app/features/quotation/presentation/pages/quotation_preview_page.dart';
import 'package:invoice_billing_app/core/common/widgets/highlight_button.dart';
import 'package:invoice_billing_app/main.dart';

class QuotationPage extends StatefulWidget {
  /// If quotation is provided, the page will be in edit mode
  final Quotation? quotation;

  const QuotationPage({super.key, this.quotation});

  /// Route for edit mode - navigates to this page with a quotation
  static Route editRoute(Quotation quotation) => CupertinoPageRoute(
        builder: (context) => QuotationPage(quotation: quotation),
      );

  @override
  State<QuotationPage> createState() => _QuotationPageState();
}

class _QuotationPageState extends State<QuotationPage> {
  int selectedStep = 0;
  final PageController pageController = PageController();
  final formKey = GlobalKey<FormState>();

  bool get isEditMode => widget.quotation != null;

  List<String> get title => isEditMode
      ? ["Edit Quotation", "Preview Quotation"]
      : ["Create Quotation", "Preview Quotation"];

  List<String> get buttonTitle => isEditMode
      ? ["Preview", "Update Quotation"]
      : ["Preview", "Generate Quotation"];

  void _movePage({required int pageInt}) {
    setState(() {
      selectedStep = pageInt;
    });
    pageController.animateToPage(pageInt,
        duration: Duration(milliseconds: 300), curve: Curves.linear);
  }

  _initiateQuotationController() {
    if (isEditMode) {
      // Edit mode: load existing quotation into controller
      context.read<AppUserCubit>().quotationController =
          QuotationController.fromQuotation(widget.quotation!);
    } else {
      // Create mode: initialize new controller if needed
      if (context.read<AppUserCubit>().quotationController == null) {
        context.read<AppUserCubit>().quotationController =
            QuotationController();
        context
            .read<AppUserCubit>()
            .quotationController!
            .customerStateNameController
            .text = "TAMIL NADU";
        context
            .read<AppUserCubit>()
            .quotationController!
            .customerCodeController
            .text = "33";
      }
    }
  }

  @override
  void initState() {
    _initiateQuotationController();
    super.initState();
  }

  void _generateOrUpdateQuotation() {
    if (!mounted) return;
    final bloc = context.read<QuotationBloc>();
    if (bloc.isClosed) return;

    final quotationController =
        context.read<AppUserCubit>().quotationController!;
    final quotationModel = quotationController.toQuotationModel();

    if (isEditMode) {
      // Update existing quotation
      bloc.add(UpdateQuotation(quotationModel));
    } else {
      // Create new quotation
      bloc.add(CreateQuotation(quotationModel));
    }
  }

  void _deleteQuotation() {
    showAppDialog(
      context: context,
      title: "Delete Quotation",
      text: "Are you sure you want to delete this quotation?",
      onPressed: () {
        Navigator.of(context).pop(); // Close dialog
        if (!mounted) return;
        final bloc = context.read<QuotationBloc>();
        if (bloc.isClosed) return;

        final quotationController =
            context.read<AppUserCubit>().quotationController!;
        bloc.add(DeleteQuotation(quotationController.toQuotationModel()));
      },
    );
  }

  void _printQuotation() {
    if (!mounted) return;
    final bloc = context.read<QuotationBloc>();
    if (bloc.isClosed) return;

    final quotationController =
        context.read<AppUserCubit>().quotationController!;
    final user = context.read<AppUserCubit>().user;
    bloc.add(
      PrintQuotation(
        quotation: quotationController.toQuotationModel(),
        user: user,
      ),
    );
  }

  void _resetQuotationController() {
    context.read<AppUserCubit>().quotationController = QuotationController();
    context
        .read<AppUserCubit>()
        .quotationController!
        .customerStateNameController
        .text = "TAMIL NADU";
    context
        .read<AppUserCubit>()
        .quotationController!
        .customerCodeController
        .text = "33";
    _movePage(pageInt: 0);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget content = BlocListener<QuotationBloc, QuotationState>(
      listener: (context, state) {
        if (state is QuotationSuccess) {
          showSnackBar(context: context, text: state.message);
          if (isEditMode) {
            Navigator.of(context).pop(); // Go back to list
          } else {
            _resetQuotationController();
          }
        }
        if (state is QuotationDeleted) {
          showSnackBar(context: context, text: state.message);
          Navigator.of(context).pop(); // Go back to list
        }
        if (state is QuotationFailure) {
          showSnackBar(context: context, text: state.message);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: isEditMode
              ? null
              : BoxDecoration(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              ListTile(
                leading: (selectedStep == 1 || isEditMode)
                    ? IconButton(
                        onPressed: () {
                          if (selectedStep == 1) {
                            _movePage(pageInt: 0);
                          } else if (isEditMode) {
                            Navigator.of(context).pop();
                          }
                        },
                        icon: Icon(Icons.arrow_back_ios_new_rounded))
                    : null,
                title: Text(
                  title[selectedStep],
                  style: const TextStyle(fontSize: 25),
                  textAlign: TextAlign.start,
                ),
                trailing: BlocBuilder<QuotationBloc, QuotationState>(
                  builder: (context, state) {
                    final isLoading = state is QuotationLoading;
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isEditMode && selectedStep == 1) ...[
                          BasicButton(
                            color: Colors.red,
                            width: 100,
                            text: "Delete",
                            onPressed: isLoading ? () {} : _deleteQuotation,
                          ),
                          const SizedBox(width: 10),
                          BasicButton(
                            color: AppColors.secondaryColor,
                            width: 100,
                            text: "Print",
                            onPressed: isLoading ? () {} : _printQuotation,
                          ),
                          const SizedBox(width: 10),
                        ],
                        BasicButton(
                          color: isLoading
                              ? AppColors.primaryColor.withAlpha(100)
                              : AppColors.primaryColor,
                          width: selectedStep == 0
                              ? 150
                              : (isEditMode ? 180 : 200),
                          text: isLoading
                              ? "Saving..."
                              : buttonTitle[selectedStep],
                          onPressed: () {
                            if (isLoading) return;
                            if (selectedStep == 0) {
                              _movePage(pageInt: 1);
                            } else {
                              _generateOrUpdateQuotation();
                            }
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        HighlightButton(
                          isSelected: selectedStep == 0,
                          onTap: () {
                            _movePage(pageInt: 0);
                          },
                          step: "1",
                          title: "Details",
                          description: isEditMode
                              ? "Edit Quotation details"
                              : "Enter Quotation details",
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
                          description: isEditMode
                              ? "Preview and Update Quotation"
                              : "Preview and Generate Quotation",
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: PageView(
                        controller: pageController,
                        children: [
                          CreateQuotationPage(),
                          QuotationPreviewPage(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Wrap with WindowTitleBar and background in edit mode
    if (isEditMode) {
      return WindowTitleBar(
        child: Scaffold(
          body: Container(
            decoration: AppTheme.backgroundColor2Theme,
            child: content,
          ),
        ),
      );
    }

    return content;
  }
}
