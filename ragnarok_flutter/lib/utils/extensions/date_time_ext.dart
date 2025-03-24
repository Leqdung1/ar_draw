import 'package:intl/intl.dart';
import 'package:ragnarok_flutter/constants/date_format_const.dart';

extension DateTimeExt on DateTime {
  ///-------------------------------------------------------------------------///
  ///                           FORMAT DATETIME                               ///
  ///-------------------------------------------------------------------------///
  /// format the date time to string
  String format(String format) => DateFormat(format).format(this);

  /// format yyyy-MM-dd, ex: 2021-01-01
  String get toyyyyMMdd => format(DateFormatConst.yyyyMMdd);

  /// format yyyy/MM/dd, ex: 2021/01/01
  String get toyyyyMMdd2 => format(DateFormatConst.yyyyMMdd2);

  /// format yyyy-MM-dd HH:mm:ss, ex: 2021-01-01 00:00:00
  String get toyyyyMMddHHmmss => format(DateFormatConst.yyyyMMddHHmmss);

  /// format yyyy/MM/dd HH:mm:ss, ex: 2021/01/01 00:00:00
  String get toyyyyMMddHHmmss2 => format(DateFormatConst.yyyyMMddHHmmss2);

  /// format yyyy-MM-dd HH:mm, ex: 2021-01-01 00:00
  String get toyyyyMMddHHmm => format(DateFormatConst.yyyyMMddHHmm);

  /// format yyyy/MM/dd HH:mm, ex: 2021/01/01 00:00
  String get toyyyyMMddHHmm2 => format(DateFormatConst.yyyyMMddHHmm);

  /// format dd-MM-yyyy, ex: 01-01-2021
  String get toddMMyyyy => format(DateFormatConst.ddMMyyyy);

  /// format dd/MM/yyyy, ex: 01/01/2021
  String get toddMMyyyy2 => format(DateFormatConst.ddMMyyyy2);

  /// format dd-MM-yyyy HH:mm:ss, ex: 01-01-2021 00:00:00
  String get toddMMyyyyHHmmss => format(DateFormatConst.ddMMyyyyHHmmss);

  /// format dd/MM/yyyy HH:mm:ss, ex: 01/01/2021 00:00:00
  String get toddMMyyyyHHmmss2 => format(DateFormatConst.ddMMyyyyHHmmss2);

  /// format dd-MM-yyyy HH:mm, ex: 01-01-2021 00:00
  String get toddMMyyyyHHmm => format(DateFormatConst.ddMMyyyyHHmm);

  /// format dd/MM/yyyy HH:mm, ex: 01/01/2021 00:00
  String get toddMMyyyyHHmm2 => format(DateFormatConst.ddMMyyyyHHmm);

  /// format HH:mm:ss, ex: 00:00:00
  String get toHHmmss => format(DateFormatConst.HHmmss);

  /// format HH:mm, ex: 00:00
  String get toHHmm => format(DateFormatConst.HHmm);

  /// format MMM dd, yyyy, ex: Jan 01, 2021
  String get toMMMddyyyy => format(DateFormatConst.MMMddyyyy);

  /// format MMMM dd, yyyy, ex: January 01, 2021
  String get toMMMMddyyyy => format(DateFormatConst.MMMMddyyyy);

  /// format EEE, MMM dd, yyyy, ex: Fri, Jan 01, 2021
  String get toEEEMMMddyyyy => format(DateFormatConst.EEEMMMddyyyy);

  /// format EEEE, MMMM dd, yyyy, ex: Friday, January 01, 2021
  String get toEEEEMMMMddyyyy => format(DateFormatConst.EEEEMMMMddyyyy);

  /// format hh:mm a, ex: 12:00 AM
  String get tohhmma => format(DateFormatConst.hhmma);

  /// format hh:mm:ss a, ex: 12:00:00 AM
  String get tohhmmssa => format(DateFormatConst.hhmmssa);

  /// format MM/dd/yyyy, ex: 01/01/2021
  String get toMMddyyyy2 => format(DateFormatConst.MMddyyyy2);

  /// format MM-dd-yyyy, ex: 01-01-2021
  String get toMMddyyyy => format(DateFormatConst.MMddyyyy);

  /// format MMMM yyyy, ex: January 2021
  String get toMMMMyyyy => format(DateFormatConst.MMMMyyyy);

  /// format yyyy, ex: 2021
  String get toyyyy => format(DateFormatConst.yyyy);

  ///-------------------------------------------------------------------------///
  ///                           DATE TIME OPERATIONS                          ///
  ///-------------------------------------------------------------------------///
  /// to the beginning of the day
  DateTime get toBeginningOfDay => DateTime(year, month, day);

  /// to the end of the day
  DateTime get toEndOfDay => DateTime(year, month, day, 23, 59, 59, 999, 999);

  /// to the beginning of the Week
  /// startWeekday: 1 = Monday, 7 = Sunday
  DateTime toBeginningOfWeek([int startWeekday = 1]) {
    final dayOfWeek = weekday;
    final difference = ((dayOfWeek - startWeekday) + 7) % 7;
    return subtract(Duration(days: difference)).toBeginningOfDay;
  }

  /// to the end of the Week
  /// startWeekday: 1 = Monday, 7 = Sunday
  DateTime toEndOfWeek([int startWeekday = 1]) {
    final dayOfWeek = weekday;
    final difference = 7 - dayOfWeek + startWeekday - 1;
    return add(Duration(days: difference)).toEndOfDay;
  }

  /// to the beginning of the Month
  DateTime get toBeginningOfMonth => DateTime(year, month);

  /// to the end of the Month
  DateTime get toEndOfMonth =>
      DateTime(year, month + 1, 0, 23, 59, 59, 999, 999);

  /// to the beginning of the Year
  DateTime get toBeginningOfYear => DateTime(year);

  /// to the end of the Year
  DateTime get toEndOfYear => DateTime(year + 1, 0, 0, 23, 59, 59, 999, 999);

  /// to next day
  DateTime get nextDay => add(Duration(days: 1));

  /// to previous day
  DateTime get previousDay => subtract(Duration(days: 1));

  /// to next month
  DateTime get nextMonth {
    if (day < 28) {
      return DateTime(year, month + 1, day);
    }
    if (day >= 29 && month == 1) {
      if (isLeapYear) {
        return DateTime(year, 2, 29);
      }
      return DateTime(year, 2, 28);
    }
    if (day >= 30 && (month == 3 || month == 5 || month == 8 || month == 10)) {
      return DateTime(year, month + 1, 30);
    }
    return DateTime(year, month + 1, day);
  }

  /// number of days in the month
  int get daysInMonth => toEndOfMonth.day;

  /// number of days in the year
  int get daysInYear => isLeapYear ? 366 : 365;

  ///-------------------------------------------------------------------------///
  ///                              DATE TIME CHECK                            ///
  ///-------------------------------------------------------------------------///
  /// check if the date is same day with the other date
  bool isTheSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  /// check if the date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// check if the date is in the current week
  bool isThisWeek({int startWeekday = 1}) =>
      isTheSameWeek(DateTime.now(), startWeekday: startWeekday);

  /// check if the date is in the current month
  bool get isThisMonth => isTheSameMonth(DateTime.now());

  /// check if the date is in the current year
  bool get isThisYear => isTheSameYear(DateTime.now());

  /// check if the date is yesterday
  bool get isYesterday =>
      isTheSameDay(DateTime.now().subtract(Duration(days: 1)));

  /// check if the date is tomorrow
  bool get isTomorrow => isTheSameDay(DateTime.now().add(Duration(days: 1)));

  /// check if the date is in the past
  bool get isInThePast => isBefore(DateTime.now().toBeginningOfDay);

  /// check if the date is in the future
  bool get isInTheFuture => isAfter(DateTime.now().toEndOfDay);

  /// check if the date is in the same week with the other date
  bool isTheSameWeek(DateTime other, {int startWeekday = 1}) {
    if (isTheSameDay(other)) return true;
    final beginningOfWeek = toBeginningOfWeek(startWeekday);
    final endOfWeek = toEndOfWeek(startWeekday);
    return beginningOfWeek.isBefore(other) && endOfWeek.isAfter(other);
  }

  /// check if the date is in the same month with the other date
  bool isTheSameMonth(DateTime other) =>
      year == other.year && month == other.month;

  /// check if the date is in the same year with the other date
  bool isTheSameYear(DateTime other) => year == other.year;

  /// check if the date is a leap year
  bool get isLeapYear => year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);

  /// check is the date is End of the Month
  bool get isEndOfMonth => day == daysInMonth;
}
