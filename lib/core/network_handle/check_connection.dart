import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

Future<bool> checkConnection() async {
  return !(await InternetConnection().hasInternetAccess);
}
