import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_billing_app/core/common/widgets/basic_button.dart';
import 'package:invoice_billing_app/core/common/widgets/basic_text_field.dart';
import 'package:invoice_billing_app/core/cubit/app_user/app_user_cubit.dart';
import 'package:invoice_billing_app/core/entities/user.dart';
import 'package:invoice_billing_app/core/theme/app_colors.dart';
import 'package:invoice_billing_app/core/theme/app_theme.dart';
import 'package:invoice_billing_app/core/utils/loader.dart';
import 'package:invoice_billing_app/core/utils/show_snackbar.dart';
import 'package:invoice_billing_app/features/settings/presentation/bloc/settings_bloc.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController companyAddressController =
      TextEditingController();
  final TextEditingController stateNameController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController companyGSTINController = TextEditingController();
  final TextEditingController companyAccountNumberController =
      TextEditingController();
  final TextEditingController bankBranchController = TextEditingController();
  final TextEditingController accountIFSCController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  File? _logoFile;
  late User user;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  void _initializeUserData() async {
    user = context.read<AppUserCubit>().user;

    mobileNumberController.text = user.mobileNumber;
    companyNameController.text = user.companyName;
    companyAddressController.text = user.companyAddress;
    stateNameController.text = user.stateName;
    codeController.text = user.code;
    companyGSTINController.text = user.companyGSTIN;
    companyAccountNumberController.text = user.companyAccountNumber;
    bankBranchController.text = user.bankBranch;
    accountIFSCController.text = user.accountIFSC;
    bankNameController.text = user.bankName;
    context
        .read<SettingsBloc>()
        .add(SettingsInitialize(imageLink: user.companyLogo));
  }

  Future<void> _pickLogo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        context.read<SettingsBloc>().logo = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _logoFile = context.watch<SettingsBloc>().logo;
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
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: BlocConsumer<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state is SettingsFailure) {
              showSnackBar(context: context, text: state.message);
            }
            if (state is SettingsSuccess) {
              context.read<AppUserCubit>().user = state.user;
              showSnackBar(context: context, text: state.message);
            }
          },
          builder: (context, state) {
            if (state is SettingsLoading) {
              return Loader();
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    "Settings",
                    style: TextStyle(
                        fontSize: 30, color: AppColors.selectedFontColor),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _pickLogo,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color:
                                AppColors.secondaryColor.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.secondaryColor, width: 2),
                            image: _logoFile != null
                                ? DecorationImage(
                                    image: FileImage(_logoFile!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: _logoFile == null
                              ? Icon(
                                  Icons.add_a_photo_rounded,
                                  color: AppColors.secondaryColor,
                                  size: 40,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 50),
                      Expanded(
                        child: Column(
                          children: [
                            BasicTextField(
                                controller: companyNameController,
                                hintText: "Company Name"),
                            BasicTextField(
                                controller: mobileNumberController,
                                hintText: "Mobile Number"),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                          child: BasicTextField(
                              controller: companyAddressController,
                              hintText: "Company Address")),
                      Expanded(
                          child: BasicTextField(
                              controller: stateNameController,
                              hintText: "State Name")),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                          child: BasicTextField(
                              controller: codeController, hintText: "Code")),
                      Expanded(
                          child: BasicTextField(
                              controller: companyGSTINController,
                              hintText: "GSTIN")),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                          child: BasicTextField(
                              controller: companyAccountNumberController,
                              hintText: "Bank Account Number")),
                      Expanded(
                          child: BasicTextField(
                              controller: bankBranchController,
                              hintText: "Bank Branch")),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                          child: BasicTextField(
                              controller: bankNameController,
                              hintText: "Bank Name")),
                      Expanded(
                          child: BasicTextField(
                              controller: accountIFSCController,
                              hintText: "IFSC")),
                    ],
                  ),
                  const SizedBox(height: 20),
                  BasicButton(
                    text: "Save",
                    onPressed: () {
                      context.read<SettingsBloc>().add(SettingsProfileSave(
                            user: User(
                              uid: user.uid,
                              email: user.email,
                              mobileNumber: mobileNumberController.text.trim(),
                              companyLogo: user.companyLogo,
                              companyName: companyNameController.text.trim(),
                              companyAddress:
                                  companyAddressController.text.trim(),
                              stateName: stateNameController.text.trim(),
                              code: codeController.text.trim(),
                              companyGSTIN: companyGSTINController.text.trim(),
                              companyAccountNumber:
                                  companyAccountNumberController.text.trim(),
                              bankBranch: bankBranchController.text.trim(),
                              bankName: bankNameController.text.trim(),
                              accountIFSC: accountIFSCController.text.trim(),
                            ),
                            imageFile: _logoFile!,
                          ));
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
