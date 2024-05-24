// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Project imports:
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/auth/data/datasources/auth_preferences_helper.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

class NotificationService {
  static NotificationService? _instance;

  NotificationService._internal() {
    _instance = this;
  }

  factory NotificationService() => _instance ?? NotificationService._internal();

  static FirebaseMessaging? _messaging;

  static FirebaseMessaging get messaging {
    return _messaging ??= FirebaseMessaging.instance;
  }

  Future<void> init() async {
    final settings = await messaging.requestPermission();
    final fcmToken = await messaging.getToken();

    if (fcmToken != null) {
      await AuthPreferencesHelper().setFcmToken(fcmToken);
    }

    // For iOS Notification in foreground
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // For Android Notification in foreground
    FirebaseMessaging.onMessage.listen(handleForegroundMessage);

    // For background message
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    debugPrint('notification status: ${settings.authorizationStatus.name}');
    debugPrint('token: $fcmToken');
  }

  void handleForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;

    if (notification == null) return;

    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    final localNotifications = FlutterLocalNotificationsPlugin();

    await localNotifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@drawable/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (details) {
        if (CredentialSaver.user != null) {
          navigatorKey.currentState!.pushNamed(
            CredentialSaver.user!.role == 'admin' ? adminHomeRoute : mainMenuRoute,
          );
        }
      },
    );

    await localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: channel.importance,
          icon: '@drawable/ic_launcher',
        ),
      ),
      payload: jsonEncode(message.toMap()),
    );
  }
}
