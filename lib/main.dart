import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:invoice_billing_app/core/cubit/app_user/app_user_cubit.dart';
import 'package:invoice_billing_app/core/theme/app_colors.dart';
import 'package:invoice_billing_app/core/utils/loader.dart';
import 'package:invoice_billing_app/core/utils/show_snackbar.dart';
import 'package:invoice_billing_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:invoice_billing_app/features/auth/presentation/pages/auth_details_page.dart';
import 'package:invoice_billing_app/features/auth/presentation/pages/auth_page.dart';
import 'package:invoice_billing_app/features/dashboard/presentation/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:invoice_billing_app/features/initialize_and_error/presentation/pages/initialize_page.dart';
import 'package:invoice_billing_app/features/initialize_and_error/presentation/pages/network_error_page.dart';
import 'package:invoice_billing_app/features/invoice/presentation/bloc/create_invoice_bloc.dart';
import 'package:invoice_billing_app/features/invoice_edit/presentation/bloc/edit_invoice_bloc.dart';
import 'package:invoice_billing_app/features/main_navigation/presentation/pages/main_navigation_page.dart';
import 'package:invoice_billing_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:invoice_billing_app/features/quotation/presentation/bloc/quotation_bloc.dart';
import 'package:invoice_billing_app/features/quotation_edit/presentation/bloc/edit_quotation_bloc.dart';
import 'package:invoice_billing_app/init_dependencies.dart';
import 'package:window_manager/window_manager.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = WindowOptions(
    titleBarStyle: TitleBarStyle.hidden,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  doWhenWindowReady(() {
    final initialSize = Size(1000, 600);
    appWindow.size = initialSize;
    appWindow.minSize = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.title = "Invoice Generator";
    appWindow.show();
  });

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: InternetConnection().hasInternetAccess,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return InitializePage();
        }
        if (snapshot.data == false) {
          return NetworkErrorPage(
            onPressed: () {
              setState(() {});
            },
          );
        }

        return FutureBuilder<bool>(
          future: initDependencies(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return InitializePage();
            }
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => serviceLocator<AppUserCubit>(),
                ),
                BlocProvider(
                  create: (context) => serviceLocator<AuthBloc>(),
                ),
                BlocProvider(
                  create: (context) => serviceLocator<CreateInvoiceBloc>(),
                ),
                BlocProvider(
                  create: (context) => serviceLocator<DashboardBloc>(),
                ),
                BlocProvider(
                  create: (context) => serviceLocator<EditInvoiceBloc>(),
                ),
                BlocProvider(
                  create: (context) => serviceLocator<SettingsBloc>(),
                ),
                BlocProvider(
                  create: (context) => serviceLocator<QuotationBloc>(),
                ),
                BlocProvider(
                  create: (context) => serviceLocator<EditQuotationBloc>(),
                ),
              ],
              child: StartingPage(),
            );
          },
        );
      },
    );
  }
}

class StartingPage extends StatefulWidget {
  const StartingPage({super.key});

  @override
  State<StartingPage> createState() => _StartingPageState();
}

class _StartingPageState extends State<StartingPage> {
  @override
  void initState() {
    context.read<AppUserCubit>().updateUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WindowTitleBar(child: _blocWidget()),
      title: "Invoice Generator",
      theme: AppTheme.lightTheme,
    );
  }

  Widget _blocWidget() {
    return BlocConsumer<AppUserCubit, AppUserState>(
      listener: (context, state) {
        if (state is AppUserFailure) {
          showSnackBar(context: context, text: state.message);
        }
      },
      builder: (context, state) {
        if (state is AppUserInitial || state is AppUserLoading) {
          return Scaffold(
            body: Loader(),
          );
        }
        if (state is AppUserDetailsUpdate) {
          return AuthDetailsPage();
        }
        if (state is AppUserLoggedIn) {
          return MainNavigationPage();
        }
        if (state is AppUserNotLoggedIn || state is AppUserFailure) {
          return AuthPage();
        }
        return Scaffold(
          body: Loader(),
        );
      },
    );
  }
}

class WindowTitleBar extends StatelessWidget {
  final Widget child;
  const WindowTitleBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        WindowTitleBarBox(
          child: SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                  child: MoveWindow(), // Makes the title bar draggable
                ),

                WindowButtons(), // Custom window buttons
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Custom Window Buttons
final buttonColors = WindowButtonColors(
  iconNormal: Colors.white,
  mouseOver: AppColors.primaryColor,
  mouseDown: AppColors.primaryColor.withValues(alpha: 0.7),
  iconMouseOver: Colors.white,
  iconMouseDown: Colors.white,
);

class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(
          colors: buttonColors,
          animate: true,
        ),
        MaximizeWindowButton(
          colors: buttonColors,
          animate: true,
        ),
        CloseWindowButton(
          colors: buttonColors,
          animate: true,
        ),
      ],
    );
  }
}
