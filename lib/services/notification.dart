import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> init({Function(String?)? onSelectNotification}) async {
    final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
          requestSoundPermission: false,
          requestBadgePermission: false,
          requestAlertPermission: false,
        );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    _notifications.initialize(initializationSettings, onSelectNotification: onSelectNotification);
  }

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        // playSound: true,
        // priority: Priority.high,
        importance: Importance.max,
      ),
      iOS: IOSNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        badgeNumber: 1,
        attachments: [],
        subtitle: "SUBTITLE", 
        threadIdentifier: ""
      )
    );
  }

  static Future showNotifications({int id = 0, String? title, String? body, String? payload}) async {
    await _notifications.show(id, title, body, 
      await _notificationDetails(),
      payload: payload,
    );
  }
}