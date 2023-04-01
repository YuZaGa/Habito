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
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin
          flutterLocalNotificationsPlugin}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channelId',
      'channelName',
      //'channelDescription',
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
      required FlutterLocalNotificationsPlugin
          flutterLocalNotificationsPlugin}) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'scheduled title',
      'scheduled body',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      const NotificationDetails(
          android: AndroidNotificationDetails(
              'your channel id', 'your channel name')),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}

  /*Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
showDialog(
      //context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SecondScreen(payload),
                ),
              );
            },
          )
        ],
      ),
    );
    Get.dialog(Text("Welcome"));
  }

  void selectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }
    Get.to(() => SecondScreen(payload));
  }
}

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