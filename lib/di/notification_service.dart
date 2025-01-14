import 'package:e_sport/util/colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  @pragma('vm:entry-point')
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('Handling background message: ${message.messageId}');
  }

  // Firebase Messaging instance
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // Flutter Local Notifications plugin instance
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Notification channel details
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  Future<void> initialize() async {
    // Request permission for iOS devices
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get FCM token
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token'); // Save this token for sending notifications

    // Initialize local notifications
    await _initializeLocalNotifications();

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle messages when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleForegroundMessage(message);
    });

    // Handle when app is opened from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleTerminatedMessage(message);
      }
    });

    // Handle when app is in background and user taps on notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleBackgroundMessage(message);
    });
  }

  Future<void> _initializeLocalNotifications() async {
    // Initialize settings for Android
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@drawable/ic_stat_notify');

    // Initialize settings for iOS
    const DarwinInitializationSettings iOSSettings =
        DarwinInitializationSettings(
            defaultPresentAlert: true,
            defaultPresentBadge: true,
            defaultPresentSound: true);

    // Initialize plugin
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        _handleNotificationTap(response);
      },
    );

    // Create high importance notification channel
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<String?> getFCMToken() async {
    String? token = await _firebaseMessaging.getToken();
    return token;
  }

  void _handleForegroundMessage(RemoteMessage message) {
    if (message.notification != null) {
      _showLocalNotification(
        id: message.hashCode,
        title: message.notification!.title,
        body: message.notification!.body,
        payload: message.data.toString(),
      );
    }
  }

  Future<void> _showLocalNotification({
    required int id,
    String? title,
    String? body,
    String? payload,
  }) async {
    await _localNotifications.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: "@drawable/ic_stat_notify", color: AppColor().primaryColor
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }

  void _handleNotificationTap(NotificationResponse response) {
    // Handle notification tap based on payload
    if (response.payload != null) {
      // Navigate to specific screen or perform action
      print('Notification tapped with payload: ${response.payload}');
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    // Handle notification tap when app is in background
    print('Handling background message: ${message.data}');
    // Navigate to specific screen or perform action
  }

  void _handleTerminatedMessage(RemoteMessage message) {
    // Handle notification tap when app was terminated
    print('Handling terminated message: ${message.data}');
    // Navigate to specific screen or perform action
  }
}
