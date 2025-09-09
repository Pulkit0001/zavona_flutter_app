import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zavona_flutter_app/core/domain/session_manager.dart';
import 'package:zavona_flutter_app/presentation/app/zavona_parking_app.dart';
import 'package:zavona_flutter_app/third_party_services/dependency_injection_service.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setUpLocator();
  SessionManager.initialize();
  runApp(const ZavonaParkingApp());
}
