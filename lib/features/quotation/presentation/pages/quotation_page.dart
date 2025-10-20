import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_billing_app/core/common/widgets/basic_button.dart';
import 'package:invoice_billing_app/core/cubit/app_user/app_user_cubit.dart';
import 'package:invoice_billing_app/core/entities/quotation_controller.dart';
import 'package:invoice_billing_app/core/theme/app_colors.dart';
import 'package:invoice_billing_app/core/theme/app_theme.dart';
// import 'package:invoice_billing_app/core/utils/loader.dart';
import 'package:invoice_billing_app/core/utils/show_snackbar.dart';
import 'package:invoice_billing_app/features/quotation/presentation/pages/create_quotation_page.dart';
import 'package:invoice_billing_app/features/quotation/presentation/pages/quotation_preview_page.dart';
import 'package:invoice_billing_app/core/common/widgets/highlight_button.dart';
import 'package:invoice_billing_app/core/utils/templates/quotation_template.dart';
// import 'package:invoice_billing_app/core/entities/user.dart';
// import 'package:invoice_billing_app/core/models/quotation_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class QuotationPage extends StatefulWidget {
  const QuotationPage({super.key});

  @override
  State<QuotationPage> createState() => _QuotationPageState();
}

class _QuotationPageState extends State<QuotationPage> {
  int selectedStep = 0;
  final List<String> title = ["Create Quotation", "Preview Quotation"];
  final List<String> buttonTitle = ["Preview", "Generate Quotation"];
  final PageController pageController = PageController();
  final formKey = GlobalKey<FormState>();

  void _movePage({required int pageInt}) {
    setState(() {
      selectedStep = pageInt;
    });
    pageController.animateToPage(pageInt,
        duration: Duration(milliseconds: 300), curve: Curves.linear);
  }

  _initiateQuotationController() {
    if (context.read<AppUserCubit>().quotationController == null) {
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
    }
  }

  @override
  void initState() {
    _initiateQuotationController();
    super.initState();
  }

  Future<void> _generateAndSavePDF() async {
    try {
      // Get the quotation data
      final quotationController = context.read<AppUserCubit>().quotationController!;
      final user = context.read<AppUserCubit>().user;
      
      // Convert to model
      final quotationModel = quotationController.toQuotationModel();
      
      // Generate PDF
      final pdfData = await generateQuotationPDF(user: user, quotation: quotationModel);
      
      // Save PDF to file
      final directory = await getApplicationDocumentsDirectory();
      final folderPath = path.join(directory.path, 'Quotation Documents');
      
      final folder = Directory(folderPath);
      if (!await folder.exists()) {
        await folder.create(recursive: true);
      }
      
      final filePath = path.join(folderPath, 'quotation_${quotationModel.quotationNumber}.pdf');
      final file = File(filePath);
      await file.writeAsBytes(pdfData);
      
      // Show success message
      if (mounted) {
        showSnackBar(context: context, text: "Quotation saved successfully!");
      }
      
      // Open the file
      await Process.run('explorer.exe', [filePath]);
    } catch (e) {
      if (mounted) {
        showSnackBar(context: context, text: "Error generating quotation: $e");
      }
    }
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
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
                      _generateAndSavePDF();
                    }
                  }),
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
                        description: "Enter Quotation details",
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
                        description: "Preview and Generate Quotation",
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
    );
  }
}