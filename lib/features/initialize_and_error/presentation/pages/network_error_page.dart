import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:invoice_billing_app/core/assets/app_svg.dart';
import 'package:invoice_billing_app/core/common/widgets/basic_button.dart';
import 'package:invoice_billing_app/core/theme/app_theme.dart';
import 'package:invoice_billing_app/main.dart';

class NetworkErrorPage extends StatelessWidget {
  final VoidCallback onPressed;
  const NetworkErrorPage({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: WindowTitleBar(
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  height: 300,
                  width: 300,
                  child: SvgPicture.asset(AppSvg.serverDownSvg),
                ),
              ),
              Text(
                "No Internet Connection",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              BasicButton(text: "Retry", width: 100, onPressed: onPressed)
            ],
          ),
        ),
      ),
    );
  }
}
