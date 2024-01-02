import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';

class MyNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static void requestPermissions() {

    _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();
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

  static void scheduleWeeklyNotification() async {

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'weekly_channel_id',
      'Weekly Channel',
    );
    const platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.periodicallyShow(0, "Füge jetzt Produkte zu deinem Einkaufswägen zu!", "Deine Einkaufswägen warten auf dich!", RepeatInterval.daily, platformChannelSpecifics);

  }
}
