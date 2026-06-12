import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';
import 'package:care4u_medical_booking/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class Care4UFcmService {
  Care4UFcmService._();

  static final Care4UFcmService instance = Care4UFcmService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'care4u_high_importance_channel',
    'Care4U Notifications',
    description: 'Thông báo đặt lịch, đổi lịch và hủy lịch Care4U',
    importance: Importance.high,
  );

  Future<void> init() async {
    await _requestPermission();
    await _initLocalNotifications();
    _listenForegroundMessages();
    await _listenNotificationOpened();
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('FCM permission: ${settings.authorizationStatus}');
  }

  Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initSettings = InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(settings: initSettings);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);
  }

  void _listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;

      final title = notification?.title ?? message.data['title'] ?? 'Care4U';
      final body = notification?.body ?? message.data['body'] ?? '';

      _localNotifications.show(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: title,
        body: body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        payload: message.data.toString(),
      );
    });
  }

  Future<void> _listenNotificationOpened() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Opened notification: ${message.data}');
    });

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      debugPrint('Initial notification: ${initialMessage.data}');
    }
  }

  Future<String?> getToken() async {
    final token = await _messaging.getToken();
    debugPrint('FCM TOKEN: $token');
    return token;
  }

  Future<void> registerTokenToApi({required String userId}) async {
    final token = await getToken();

    if (token == null || token.isEmpty) {
      debugPrint('Không lấy được FCM token');
      return;
    }

    await Care4UApiService().registerFcmToken(
      userId: userId,
      token: token,
      platform: Platform.isAndroid ? 'android' : 'other',
    );

    _messaging.onTokenRefresh.listen((newToken) async {
      await Care4UApiService().registerFcmToken(
        userId: userId,
        token: newToken,
        platform: Platform.isAndroid ? 'android' : 'other',
      );
    });
  }
}
