import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:zavona_flutter_app/third_party_services/crashlytics_service.dart';
import 'navigation_service.dart';

class PushNotificationService {
  static final String notificationChannelId = "zavona_messaging_channel";
  static final String notificationChannelName = "Zavona Notifications";
  static final String notificationChannelDescription = "zavona";

  // Store navigation context for notification handling
  static GlobalKey<NavigatorState>? _navigatorKey;

  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    log(message.data.toString());
  }

  static initialize({GlobalKey<NavigatorState>? navigatorKey}) async {
    try {
      _navigatorKey = navigatorKey;

      FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );
      FlutterLocalNotificationsPlugin notificationsPlugin =
          FlutterLocalNotificationsPlugin();
      initializeNotificationPlugin(notificationsPlugin);

      await _requestPermissions(firebaseMessaging);

      configureFirebaseCloudMessaging(firebaseMessaging, notificationsPlugin);
    } catch (error, stackTrace) {
      CrashlyticsService.recordError(error, stackTrace);
      log(error.toString());
    }
  }

  // //   // initialising Flutter Local Notification Plugin.
  // // //   // this plugin used to show notification only when app is in foreground.
  static initializeNotificationPlugin(
    FlutterLocalNotificationsPlugin notificationsPlugin,
  ) {
    var initializationSettingsAndroid = const AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );
    var initializationSettingsIOS = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        log(
          "${jsonDecode(response.payload ?? "")} ndsgnjdngjndjngjdngjkdnbgkjdn",
        );
        if (response.payload != null) {
          _handleNotificationClick(jsonDecode(response.payload ?? ""));
        }
      },
    );
  }

  // // here we configure Firebase cloud notifications.
  // // here we configure what should happen everytime when notification comes to mobile.
  static configureFirebaseCloudMessaging(
    FirebaseMessaging firebaseMessaging,
    FlutterLocalNotificationsPlugin notificationsPlugin,
  ) async {
    final AndroidNotificationChannel channel = AndroidNotificationChannel(
      notificationChannelId, // id
      notificationChannelName,
      description: notificationChannelDescription, // title
      importance: Importance.max,
    );
    // _requestIosPermissions(_firebaseMessaging);
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    // gets called when clicked on notification  when app is in terminated state
    firebaseMessaging.getInitialMessage().then((message) {
      log("[TerminatedState][getInitialMessage]$message");
      // handleNotificationClick();
    });

    // gets notification badge when app is on foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("[ForegroundState]$message");
      _showNotification(message, notificationsPlugin);
    });

    // gets called when clicked on notification when app is in background but not termincated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("[BckgroundState][Not Terminated][message]$message");
      _handleNotificationClick(message.data);
    });
  }

  //   // requests for iOS Permissions.
  static _requestPermissions(FirebaseMessaging firebaseMessaging) async {
    await firebaseMessaging.requestPermission(
      sound: true,
      badge: true,
      alert: true,
    );
  }

  static _showNotification(
    RemoteMessage message,
    FlutterLocalNotificationsPlugin notificationsPlugin,
  ) async {
    try {
      String? pushTitle = message.notification!.title;
      String? pushText = message.notification!.body;
      String? imageUrl = message.notification?.android?.imageUrl;
      BigPictureStyleInformation? bigPictureStyleInformation;
      List<DarwinNotificationAttachment>? attachments;
      if (imageUrl != null) {
        final http.Response response = await http.get(Uri.parse(imageUrl));
        var image = response.bodyBytes;
        bigPictureStyleInformation = BigPictureStyleInformation(
          ByteArrayAndroidBitmap.fromBase64String(base64Encode(image)),
        );
        var dir = await getApplicationDocumentsDirectory();
        File imageFile = File(
          "${dir.path}notification_image_${DateTime.now().millisecondsSinceEpoch}.${imageUrl.split(".").last}",
        );
        imageFile.writeAsBytesSync(image);
        attachments = [DarwinNotificationAttachment(imageFile.path)];
      }
      var notificationDetailsAndroid = AndroidNotificationDetails(
        notificationChannelId,
        notificationChannelName,
        channelDescription: notificationChannelDescription,
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: bigPictureStyleInformation,
      );
      var notificationDetailsIOS = DarwinNotificationDetails(
        presentSound: true,
        attachments: attachments,
      );
      var notificationDetails = NotificationDetails(
        android: notificationDetailsAndroid,
        iOS: notificationDetailsIOS,
      );

      await notificationsPlugin.show(
        message.notification.hashCode,
        pushTitle,
        pushText,
        notificationDetails,
        payload: jsonEncode(message.data),
      );
    } catch (e) {
      log(e.toString());
    }
  }

  /// Handles notification click and delegates to navigation handler
  static void _handleNotificationClick(Map<String, dynamic> data) {
    if (_navigatorKey?.currentContext != null) {
      NavigationService.handleDeepLink(data, _navigatorKey!.currentContext!);
    } else {
      log('Navigator context not available for notification navigation');
    }
  }
}
