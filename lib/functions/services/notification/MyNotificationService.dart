import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';

class MyNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static void requestPermissions() {

    _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();
  }

  static void cancelAllNotification() {

    _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.cancel(0);
    _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.cancelAll();
  }

  static Future<void> initialize() async {
    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await _notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) async {
      print(response.input);
        });
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Custom_Sound',
    );
  }

  static Future<void> showZonedNotification({
    required String title,
    required String body,
    required TZDateTime dateTime
  }) async {

    await _notificationsPlugin.zonedSchedule(
        0,
        'scheduled title',
        'scheduled body',
        TZDateTime.now(local).add(const Duration(seconds: 40)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }

  ///TODO: nicht permissions entziehen sondern. einfach alle notification löschen oder wieder rein packen

  static void scheduleWeeklyNotification() async {

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '0',
      'Weekly Channel',
    );

    const platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.periodicallyShow(0, "Heute Lust shoppen zu gehen?", "Deine Einkaufslisten warten auf dich!", RepeatInterval.everyMinute, platformChannelSpecifics);

  }
}
