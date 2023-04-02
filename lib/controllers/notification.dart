//import 'package:timezone/browser.dart';
import 'dart:math';

import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as datatz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/task.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class NotifyHelper {
  initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    _configureLocalTimeZone();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('logo');

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: null);
  }

  static Future showBigTextNoification(
      {var id = 10000,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin
          flutterLocalNotificationsPlugin}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        id, title, body, platformChannelSpecifics);
  }

  scheduleNotification(
      {required int hour,
      required int minutes,
      required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      required Task task}) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    final dateParts = task.date.split('/');
    final day = int.parse(dateParts[1]);
    final month = int.parse(dateParts[0]);
    final year = int.parse(dateParts[2]);

    var _starttime = task.startTime.split(' ')[0] + ':00';
    final formatteddateTime = DateFormat('h:mm:ss').parse(_starttime);
    final formatted = DateFormat('HH:mm:ss').format(formatteddateTime);
    final time = DateTime.parse('1970-01-01 $formatted');
    final dateTime = tz.TZDateTime(tz.getLocation('Asia/Kolkata'), year, month,
        day, time.hour, time.minute);
    final tz.TZDateTime startTime =
        tz.TZDateTime.from(dateTime, tz.local).subtract(Duration(minutes: 5));
    // Ensure the notification time is not in the past
    await flutterLocalNotificationsPlugin.zonedSchedule(
      Random().nextInt(100000),
      task.title,
      task.note,
      _convertTime(hour, minutes),
      //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      //startTime,
      const NotificationDetails(
          android: AndroidNotificationDetails(
              'your channel id', 'your channel name')),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _convertTime(int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes)
            .toLocal();
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    print(scheduledDate);
    return scheduledDate;
  }

  Future<void> _configureLocalTimeZone() async {
    datatz.initializeTimeZones();

    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }
}
