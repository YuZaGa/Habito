//import 'package:timezone/browser.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/task.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class NotifyHelper {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('logo');
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
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
      {var id = 0,
      required String title,
      required String body,
      var payload,
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
      0,
      task.title,
      task.note,
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      //startTime,
      const NotificationDetails(
          android: AndroidNotificationDetails(
              'your channel id', 'your channel name')),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
  /*scheduleNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
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
    print(dateTime);
    final tz.TZDateTime startTime =
        tz.TZDateTime.from(dateTime, tz.local).subtract(Duration(minutes: 5));
    print(startTime);
    print(tz.TZDateTime.now(tz.getLocation('Asia/Kolkata'))
        .add(const Duration(seconds: 5)));
    // Ensure the notification time is not in the past
    if (startTime.isBefore(now)) {
      return;
    }
    await flutterLocalNotificationsPlugin.zonedSchedule(
      9999,
      task.title,
      task.note,
      tz.TZDateTime.now(tz.getLocation('Asia/Kolkata'))
          .add(const Duration(seconds: 5)),
      //startTime,
      const NotificationDetails(
          android: AndroidNotificationDetails(
              'your channel id', 'your channel name')),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }*/
}

  /*

Future<void> _scheduleNotification(Task task) async {
  var scheduledTime = DateTime.parse(task.startTime)
      .subtract(Duration(minutes: 5))
      .toUtc()
      .millisecondsSinceEpoch;

  var androidDetails = AndroidNotificationDetails(
    'channelId',
    'channelName',
    //'channelDescription',
    importance: Importance.max,
    priority: Priority.high,
  );

  var notificationDetails = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    task.id!, // unique id for the notification
    task.title, // title of the notification
    task.note, // description of the notification
    tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, scheduledTime),
    notificationDetails,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}

//_scheduleNotification(task);

Future<void> scheduleNotification(DateTime startTime, int remind) async {
  if (remind <= 0) {
    return;
  }

  final now = DateTime.now();
  final scheduledDate = startTime.subtract(Duration(minutes: remind));

  if (scheduledDate.isBefore(now)) {
    return;
  }

  final androidDetails = AndroidNotificationDetails(
    'task_channel_id',
    'Task Manager',
    //'Task notifications',
    priority: Priority.high,
    importance: Importance.high,
    ticker: 'Task reminder',
  );

  final platformDetails = NotificationDetails(android: androidDetails);

  await FlutterLocalNotificationsPlugin().schedule(
    0,
    'Task reminder',
    'It is time to start your task.',
    scheduledDate,
    platformDetails,
  );
}
*/