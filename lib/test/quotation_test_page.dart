import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_billing_app/core/cubit/app_user/app_user_cubit.dart';
import 'package:invoice_billing_app/features/quotation/presentation/pages/quotation_page.dart';

class QuotationTestPage extends StatelessWidget {
  const QuotationTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quotation Feature Test'),
      ),
      body: BlocBuilder<AppUserCubit, AppUserState>(
        builder: (context, state) {
          if (state is AppUserLoggedIn) {
            return QuotationPage();
          } else {
            return Center(
              child: Text('User not logged in'),
            );
          }
        },
      ),
    );
  }
}