import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    var androidInitialize =
    const AndroidInitializationSettings("@mipmap/ic_launcher");

    /// iOS: Request notification permissions
    DarwinInitializationSettings initializationSettingsIOS =
    const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitialize,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  }

  static Future showTextNotification({
    int id = 0,
    required String title,
    required String body,
    bool playSound = true,
    bool enableVibration = true,
    var payload,
  }) async {

    AndroidNotificationDetails androidNotificationDetails =
    const AndroidNotificationDetails(
      "default_value",
      "channel_id_5",
      playSound: true,
      importance: Importance.max,
      priority: Priority.max,
      showWhen: true,
      showProgress: true,
      enableVibration: true,
    );

    DarwinNotificationDetails darwinInitializationDetails =
    const DarwinNotificationDetails(presentSound: true, presentAlert: true);

    var not = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinInitializationDetails,
    );
    await flutterLocalNotificationsPlugin.show(id, title, body, not);

  }
}