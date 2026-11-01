import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
      macOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    await _plugin.initialize(settings: settings);
  }

  Future<bool> areNotificationsEnabled() async {
    if (kIsWeb) {
      final webPlugin = _plugin.resolvePlatformSpecificImplementation<
        WebFlutterLocalNotificationsPlugin
      >();
      return webPlugin?.permissionStatus == WebNotificationPermission.granted;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();
      return await androidPlugin?.areNotificationsEnabled() ?? false;
    }

    return false;
  }

  Future<bool> requestPermission() async {
    if (kIsWeb) {
      final webPlugin = _plugin.resolvePlatformSpecificImplementation<
        WebFlutterLocalNotificationsPlugin
      >();
      if (webPlugin == null) return false;

      if (webPlugin.permissionStatus != WebNotificationPermission.granted) {
        await webPlugin.requestNotificationsPermission();
      }
      return webPlugin.permissionStatus == WebNotificationPermission.granted;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();
      if (androidPlugin == null) return false;

      if (await androidPlugin.areNotificationsEnabled() == true) {
        return true;
      }
      return await androidPlugin.requestNotificationsPermission() ?? false;
    }

    return false;
  }

  Future<void> showDemoNotification() async {
    await _plugin.show(
      id: 1001,
      title: 'Lab 10.5 - Local Notification',
      body: 'Your test notification is ready. Notifications are working!',
      notificationDetails: const NotificationDetails(
        web: WebNotificationDetails(requireInteraction: true),
        android: AndroidNotificationDetails(
          'lab10_5_demo_channel',
          'Lab 10.5 Demo',
          channelDescription: 'Notifications sent from the Lab 10.5 demo app.',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }
}
