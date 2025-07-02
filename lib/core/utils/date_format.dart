import 'package:intl/intl.dart';

String dateFormat(DateTime dateTime) {
  return DateFormat('dd MMM yyyy').format(dateTime);
}
