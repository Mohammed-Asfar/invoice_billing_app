import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:file_picker/file_picker.dart';
import 'package:invoice_billing_app/core/assets/app_svg.dart';
import 'package:invoice_billing_app/core/cubit/app_user/app_user_cubit.dart';
import 'package:invoice_billing_app/core/theme/app_colors.dart';
import 'package:invoice_billing_app/core/theme/app_theme.dart';
import 'package:invoice_billing_app/core/utils/loader.dart';
import 'package:invoice_billing_app/core/utils/show_snackbar.dart';
import 'package:invoice_billing_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:invoice_billing_app/features/auth/presentation/widgets/auth_button.dart';
import 'package:invoice_billing_app/features/auth/presentation/widgets/auth_field.dart';

class AuthDetailsPage extends StatefulWidget {
  static route() => {
        CupertinoPageRoute(
          builder: (context) => AuthDetailsPage(),
        )
      };
  const AuthDetailsPage({super.key});

  @override
  State<AuthDetailsPage> createState() => _AuthDetailsPageState();
}

class _AuthDetailsPageState extends State<AuthDetailsPage> {
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

  final PageController _pageController = PageController();
  int _currentPage = 0;
  File? _logoFile; // File for storing the selected logo image

  final formKey = GlobalKey<FormState>();

  void _goToNextPage() {
    if (_currentPage < 1 && _logoFile != null) {
      if (formKey.currentState!.validate()) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        return;
      }
      return;
    }
    showSnackBar(context: context, text: "Company logo is missing!");
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _pickLogo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _logoFile = File(result.files.single.path!);
      });
    }
  }

  @override
  void dispose() {
    mobileNumberController.dispose();
    companyNameController.dispose();
    companyAddressController.dispose();
    stateNameController.dispose();
    codeController.dispose();
    companyGSTINController.dispose();
    companyAccountNumberController.dispose();
    bankBranchController.dispose();
    accountIFSCController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            showSnackBar(context: context, text: state.message);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Loader();
          }
          return Container(
            decoration: AppTheme.backgroundColor2Theme,
            child: Form(
              key: formKey,
              child: Row(
                children: [
                  Flexible(
                    flex: 3,
                    child: BlocConsumer<AppUserCubit, AppUserState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Company details",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Expanded(
                                child: PageView(
                                  controller: _pageController,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _currentPage = index;
                                    });
                                  },
                                  children: [
                                    _buildCompanyDetailsPage(),
                                    _buildBankDetailsPage(),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Dot Navigation
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(2, (index) {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    width: _currentPage == index ? 12 : 8,
                                    height: _currentPage == index ? 12 : 8,
                                    decoration: BoxDecoration(
                                      color: _currentPage == index
                                          ? AppColors.secondaryColor
                                          : AppColors.greyColor,
                                      shape: BoxShape.circle,
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 20),
                              // Navigation Buttons
                              Row(
                                children: [
                                  if (_currentPage > 0)
                                    IconButton(
                                      onPressed: _goToPreviousPage,
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                          AppColors.secondaryColor,
                                        ),
                                        foregroundColor: WidgetStatePropertyAll(
                                          Colors.white,
                                        ),
                                      ),
                                      icon: Icon(
                                          Icons.arrow_back_ios_new_rounded),
                                    ),
                                  Spacer(),
                                  _currentPage < 1
                                      ? IconButton(
                                          onPressed: _goToNextPage,
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                              AppColors.secondaryColor,
                                            ),
                                            foregroundColor:
                                                WidgetStatePropertyAll(
                                              Colors.white,
                                            ),
                                          ),
                                          icon: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                          ),
                                        )
                                      : AuthButton(
                                          text: "Submit",
                                          onPressed: () async {
                                            if (formKey.currentState!
                                                .validate()) {
                                              final userData =
                                                  state as AppUserDetailsUpdate;
                                              context
                                                  .read<AuthBloc>()
                                                  .add(AuthUserUpdateEvent(
                                                    uid: userData.uid,
                                                    email: userData.email,
                                                    mobileNumber:
                                                        mobileNumberController
                                                            .text
                                                            .trim(),
                                                    companyLogo: _logoFile!,
                                                    companyName:
                                                        companyNameController
                                                            .text
                                                            .trim(),
                                                    companyAddress:
                                                        companyAddressController
                                                            .text
                                                            .trim(),
                                                    stateName:
                                                        stateNameController.text
                                                            .trim(),
                                                    code: codeController.text
                                                        .trim(),
                                                    companyGSTIN:
                                                        companyGSTINController
                                                            .text
                                                            .trim(),
                                                    companyAccountNumber:
                                                        companyAccountNumberController
                                                            .text
                                                            .trim(),
                                                    bankBranch:
                                                        bankBranchController
                                                            .text
                                                            .trim(),
                                                    accountIFSC:
                                                        accountIFSCController
                                                            .text
                                                            .trim(),
                                                    bankName: bankNameController
                                                        .text
                                                        .trim(),
                                                  ));
                                            }
                                          },
                                          width: 100,
                                        ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Container(
                      margin: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius:
                            BorderRadius.circular(AppTheme.borderRadius),
                      ),
                      padding: EdgeInsets.all(80),
                      child: SvgPicture.asset(
                        AppSvg.addInformationSvg,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCompanyDetailsPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickLogo,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.secondaryColor, width: 2),
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
            const SizedBox(height: 10),
            const Text(
              "Upload Company Logo",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            AuthField(
              icon: Icons.phone_rounded,
              controller: mobileNumberController,
              hintText: "Mobile Number",
            ),
            const SizedBox(height: 20),
            AuthField(
              icon: Icons.business_rounded,
              controller: companyNameController,
              hintText: "Company Name",
            ),
            const SizedBox(height: 20),
            AuthField(
              icon: Icons.location_on_rounded,
              controller: companyAddressController,
              hintText: "Company Address",
            ),
            const SizedBox(height: 20),
            AuthField(
              icon: Icons.map_rounded,
              controller: stateNameController,
              hintText: "State Name",
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBankDetailsPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            AuthField(
              icon: Icons.code_rounded,
              controller: codeController,
              hintText: "Code",
            ),
            const SizedBox(height: 20),
            AuthField(
              icon: Icons.confirmation_number_rounded,
              controller: companyGSTINController,
              hintText: "GSTIN",
            ),
            const SizedBox(height: 20),
            AuthField(
              icon: Icons.account_balance_rounded,
              controller: companyAccountNumberController,
              hintText: "Account Number",
            ),
            const SizedBox(height: 20),
            AuthField(
              icon: Icons.credit_card_rounded,
              controller: bankNameController,
              hintText: "Bank Name",
            ),
            const SizedBox(height: 20),
            AuthField(
              icon: Icons.account_balance_wallet_rounded,
              controller: bankBranchController,
              hintText: "Bank Branch",
            ),
            const SizedBox(height: 20),
            AuthField(
              icon: Icons.credit_card_rounded,
              controller: accountIFSCController,
              hintText: "IFSC Code",
            ),
          ],
        ),
      ),
    );
  }
}
