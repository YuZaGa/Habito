import 'dart:math';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as datatz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/task.dart';

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
      required Task task,
      required String name}) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      Random().nextInt(100000),
      task.title,
      'Hey ${name}! \n${task.note}',
      _convertTime(hour, minutes, task.remind),
      const NotificationDetails(
          android: AndroidNotificationDetails(
              'your channel id', 'your channel name')),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _convertTime(int hour, int minutes, int subtractMinutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes)
            .toLocal()
            .subtract(Duration(minutes: subtractMinutes));
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> _configureLocalTimeZone() async {
    datatz.initializeTimeZones();

    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }
}
