import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MyNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

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

  static void scheduleWeeklyNotification() async {
    final notifications = FlutterLocalNotificationsPlugin();

    final androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'weekly_channel_id',
      'Weekly Channel',
    );
    final platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await notifications.periodicallyShow(0, "Mache es!", "Jo", RepeatInterval.everyMinute, platformChannelSpecifics);

  }
}
