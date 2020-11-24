import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart';

class TimeInformation {
  static String getTime(String location) {
    DateTime dateTime = TZDateTime.now(getLocation(location));
    return DateFormat.jm().format(dateTime);
  }
}
