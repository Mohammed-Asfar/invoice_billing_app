import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:invoice_billing_app/core/assets/app_svg.dart';
import 'package:invoice_billing_app/core/theme/app_colors.dart';
import 'package:invoice_billing_app/core/theme/app_theme.dart';
import 'package:invoice_billing_app/core/utils/loader.dart';
import 'package:invoice_billing_app/core/utils/show_snackbar.dart';
import 'package:invoice_billing_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:invoice_billing_app/features/auth/presentation/widgets/auth_button.dart';
import 'package:invoice_billing_app/features/auth/presentation/widgets/auth_field.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            showSnackBar(context: context, text: state.message);
          }
          if (state is AuthForgotSuccess) {
            showSnackBar(context: context, text: state.message);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Loader();
          }
          return Container(
            alignment: Alignment.center,
            decoration: AppTheme.backgroundColorTheme,
            child: Stack(
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: AppColors.primaryColor,
                          )),
                    )),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: MediaQuery.of(context).size.width / 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Forgot Password",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "To reset your password, please enter your email address in the field provided. A reset link will be sent to your Gmail. Open the email, click on the link, and you will be redirected to the reset page. From there, enter a new password and click the 'Reset Password' button.",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 30),
                            AuthField(
                                controller: emailController,
                                obscureText: false,
                                hintText: "Email"),
                            const SizedBox(height: 20),
                            AuthButton(
                                text: "Reset Password",
                                onPressed: () {
                                  context.read<AuthBloc>().add(
                                      AuthForgotPassword(
                                          email: emailController.text.trim()));
                                }),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Container(
                            padding: EdgeInsets.all(50),
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              AppSvg.forgotPasswordSvg,
                              fit: BoxFit.fitWidth,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
