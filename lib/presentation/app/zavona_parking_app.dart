import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zavona_flutter_app/presentation/app/bloc/app_cubit.dart';
import 'package:zavona_flutter_app/presentation/app/bloc/app_state.dart';
import 'package:zavona_flutter_app/presentation/auth/bloc/auth_cubit.dart';
import 'package:zavona_flutter_app/presentation/common/bloc/select_location_cubit.dart';
import 'package:zavona_flutter_app/res/values/app_theme.dart';
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
      themeMode: ThemeMode.light,
      theme: AppTheme.lightTheme,
      builder: (context, child) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthCubit()),
          BlocProvider(create: (_) => AppCubit()),
          BlocProvider(create: (_) => SelectLocationCubit()),
        ],
        child: BlocListener<AppCubit, AppState>(
          listener: (context, state) {
            // Listen for app state changes
          },
          child: child ?? Offstage(),
        ),
      ),
      routerConfig: AppRouter.router,
    );
  }
}
