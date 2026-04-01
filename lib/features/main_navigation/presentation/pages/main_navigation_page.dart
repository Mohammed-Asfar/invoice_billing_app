import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_billing_app/core/cubit/app_user/app_user_cubit.dart';
import 'package:invoice_billing_app/core/theme/app_colors.dart';
import 'package:invoice_billing_app/core/theme/app_theme.dart';
import 'package:invoice_billing_app/core/domain/services/app_update_service.dart';
import 'package:invoice_billing_app/core/utils/show_app_dialog.dart';
import 'package:invoice_billing_app/core/utils/show_update_dialog.dart';
import 'package:invoice_billing_app/init_dependencies.dart';
import 'package:invoice_billing_app/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:invoice_billing_app/features/invoice/presentation/pages/invoice_page.dart';
import 'package:invoice_billing_app/features/main_navigation/presentation/widgets/navigator_list_tile.dart';
import 'package:invoice_billing_app/features/quotation/presentation/pages/quotation_page.dart';
import 'package:invoice_billing_app/features/quotation/presentation/pages/quotation_list_page.dart';
import 'package:invoice_billing_app/features/settings/presentation/pages/settings_page.dart';
// import 'package:invoice_billing_app/features/templates/presentation/pages/templates_page.dart';

class MainNavigationPage extends StatefulWidget {
  static route() => {
        CupertinoPageRoute(
          builder: (context) => MainNavigationPage(),
        )
      };
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  List<Widget> pages = [
    DashboardPage(),
    QuotationListPage(),
    InvoicePage(),
    QuotationPage(),
    // TemplatesPage(),
    SettingsPage(),
  ];
  int selectedPage = 0;

  bool ishidden = false;
  bool isAnimationOver = true;

  @override
  void initState() {
    super.initState();
    _checkForUpdate();
  }

  Future<void> _checkForUpdate() async {
    final updateService = serviceLocator<AppUpdateService>();
    final versionInfo = await updateService.checkForUpdate();
    if (versionInfo != null && mounted) {
      showUpdateDialog(context: context, versionInfo: versionInfo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppUserCubit, AppUserState>(
      listener: (context, appUserState) {},
      builder: (context, appUserState) {
        return Scaffold(
          body: Container(
            decoration: AppTheme.backgroundColor2Theme,
            child: Row(
              children: [
                // Drawer Section
                AnimatedContainer(
                  onEnd: () {
                    setState(() {
                      isAnimationOver = true;
                    });
                  },
                  duration: Duration(milliseconds: 500),
                  curve: Curves.linear,
                  width: ishidden ? 70 : 270,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ishidden
                              ? Container()
                              : isAnimationOver
                                  ? _appLogoWidget()
                                  : Container(),
                          ishidden ? Container() : Spacer(),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                isAnimationOver = false;
                                ishidden = !ishidden;
                              });
                            },
                            icon: Icon(
                              ishidden
                                  ? Icons.keyboard_double_arrow_right_rounded
                                  : Icons.keyboard_double_arrow_left_rounded,
                              color: AppColors.selectedFontColor,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ishidden
                          ? Container()
                          : isAnimationOver
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    "Main",
                                    style: TextStyle(
                                      color: AppColors.selectedFontColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )
                              : Container(),
                      SizedBox(
                        height: 5,
                      ),
                      NavigatorListTile(
                        isAnimationOver: isAnimationOver,
                        ishidden: ishidden,
                        isSelected: selectedPage == 0,
                        onTap: () {
                          setState(() {
                            selectedPage = 0;
                          });
                        },
                        icon: Icons.dashboard_rounded,
                        title: "Dashboard",
                      ),
                      NavigatorListTile(
                        isAnimationOver: isAnimationOver,
                        ishidden: ishidden,
                        isSelected: selectedPage == 1,
                        onTap: () {
                          setState(() {
                            selectedPage = 1;
                          });
                        },
                        icon: Icons.list_alt_rounded,
                        title: "Quotation List",
                      ),
                      NavigatorListTile(
                        isAnimationOver: isAnimationOver,
                        ishidden: ishidden,
                        isSelected: selectedPage == 2,
                        onTap: () {
                          setState(() {
                            selectedPage = 2;
                          });
                        },
                        icon: Icons.request_quote,
                        title: "Invoice",
                      ),
                      NavigatorListTile(
                        isAnimationOver: isAnimationOver,
                        ishidden: ishidden,
                        isSelected: selectedPage == 3,
                        onTap: () {
                          setState(() {
                            selectedPage = 3;
                          });
                        },
                        icon: Icons.description_rounded,
                        title: "Create Quotation",
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ishidden
                          ? Container()
                          : isAnimationOver
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    "Other",
                                    style: TextStyle(
                                      color: AppColors.selectedFontColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )
                              : Container(),
                      SizedBox(
                        height: 5,
                      ),
                      // NavigatorListTile(
                      //   isAnimationOver: isAnimationOver,
                      //   ishidden: ishidden,
                      //   isSelected: selectedPage == 3,
                      //   onTap: () {
                      //     setState(() {
                      //       selectedPage = 3;
                      //     });
                      //   },
                      //   icon: Icons.layers,
                      //   title: "Templates",
                      // ),
                      NavigatorListTile(
                        isAnimationOver: isAnimationOver,
                        ishidden: ishidden,
                        isSelected: selectedPage == 4,
                        onTap: () {
                          setState(() {
                            selectedPage = 4;
                          });
                        },
                        icon: Icons.settings_rounded,
                        title: "Settings",
                      ),
                      Spacer(),
                      NavigatorListTile(
                        isAnimationOver: isAnimationOver,
                        ishidden: ishidden,
                        isSelected: false,
                        onTap: () {
                          showAppDialog(
                            onPressed: () {
                              Navigator.of(context).pop();
                              context.read<AppUserCubit>().userLogout();
                            },
                            context: context,
                            text: "Do you want to logout ?",
                            title: "Logout",
                          );
                        },
                        icon: Icons.logout_rounded,
                        title: "Logout",
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: pages[selectedPage],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _appLogoWidget() {
    return Row(
      children: [
        SizedBox(
          width: 5,
        ),
        Container(
          decoration: AppTheme.backgroundColorTheme
              .copyWith(borderRadius: BorderRadius.circular(100)),
          padding: EdgeInsets.all(15),
          child: Text(
            "TBS",
            style: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          "Invoice \nGenearator",
          style: TextStyle(
            color: AppColors.selectedFontColor,
          ),
        ),
      ],
    );
  }
}
