import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeFormatter {
  static String getFormattedMonthDay(DateTime date) {
    String formattedDate = DateFormat('MMMM dd').format(date);
    return formattedDate;
  }

  static String getFormattedStringToWeekDate(String date) {
    String formattedDate =
        DateFormat('EEEE, dd.MM.yy').format(getDateTimeFromString(date));
    return formattedDate;
  }

  static String? getFormattedWeekDayMonth(DateTime? date) {
    if (date != null) {
      String formattedDate = DateFormat('EEE, dd MMMM').format(date);
      return formattedDate;
    }
    return null;
  }

  static DateTime getDateTimeFromString(String date) {
    return DateTime.parse(date);
  }

  static String getFormattedTime(String date, BuildContext context) {
    DateTime dateTime = getDateTimeFromString(date);
    TimeOfDay timeOfDay = TimeOfDay.fromDateTime(dateTime);
    return timeOfDay.format(context);
  }

  static String getFormattedTimeWeekDate(String date) {
    DateTime dateTime = getDateTimeFromString(date);
    String formattedDate = DateFormat('hh:mm a, EEE, dd.MM').format(dateTime);
    return formattedDate;
  }

  static TimeOfDay getFormattedStringToTimeOfDay(String date) {
    DateTime dateTime = getDateTimeFromString(date);
    return TimeOfDay.fromDateTime(dateTime);
  }

  static String getStringFromDateTime(DateTime date, TimeOfDay time) {
    final newDate =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    return newDate.toString().replaceAll(" ", "T");
  }

  static String getStringFromDate(DateTime date) {
    return date.toString().replaceAll(" ", "T");
  }

  static DateTime getDateTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}
