import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:invoice_billing_app/core/assets/app_svg.dart';
import 'package:invoice_billing_app/core/theme/app_theme.dart';
import 'package:invoice_billing_app/core/utils/loader.dart';
import 'package:invoice_billing_app/core/utils/show_snackbar.dart';
import 'package:invoice_billing_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:invoice_billing_app/features/auth/presentation/pages/forget_password_page.dart';
import 'package:invoice_billing_app/features/auth/presentation/widgets/auth_button.dart';
import 'package:invoice_billing_app/features/auth/presentation/widgets/auth_field.dart';

class AuthPage extends StatefulWidget {
  static route() => {
        MaterialPageRoute(
          builder: (context) => AuthPage(),
        )
      };
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
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
            decoration: AppTheme.backgroundColorTheme,
            child: Form(
              key: formKey,
              child: Center(
                child: Row(
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
                              "Get Started",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Welcome to TBS Invoice generator",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 30),
                            AuthField(
                              controller: emailController,
                              obscureText: false,
                              hintText: "Email",
                            ),
                            const SizedBox(height: 15),
                            AuthField(
                                controller: passwordController,
                                obscureText: true,
                                hintText: "Password"),
                            const SizedBox(height: 15),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(CupertinoPageRoute(
                                    builder: (context) => ForgetPasswordPage(),
                                  ));
                                },
                                child: Text(
                                  "Forgot password ?",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            AuthButton(
                                text: "Sign in",
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    context
                                        .read<AuthBloc>()
                                        .add(AuthSignInEvent(
                                          email: emailController.text
                                              .trim()
                                              .toLowerCase(),
                                          password:
                                              passwordController.text.trim(),
                                        ));
                                  }
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
                              AppSvg.loginSvg,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
