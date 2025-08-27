import 'package:flutter/material.dart';
import 'package:zavona_flutter_app/third_party_services/deep_link_service.dart';
import '../../core/router/app_router.dart';
import '../../third_party_services/push_notification_service.dart';

class ZavonaParkingApp extends StatelessWidget {
  const ZavonaParkingApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize push notification service with the router's navigator key
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DeepLinkService.initialize(
        navigatorKey: AppRouter.router.routerDelegate.navigatorKey,
      );
      PushNotificationService.initialize(
        navigatorKey: AppRouter.router.routerDelegate.navigatorKey,
      );
    });

    return MaterialApp.router(
      title: 'Zavona',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      routerConfig: AppRouter.router,
    );
  }
}
