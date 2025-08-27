import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:zavona_flutter_app/res/values/remote_config_constants.dart';
import 'package:zavona_flutter_app/third_party_services/crashlytics_service.dart';

class RemoteConfigService {
  static const String kBaseURLKey = 'base_url';
  static const String kMinVersionKey = 'min_version';
  static const String kLatestVersionKey = 'latest_version';


  static initialize() async {
    try {
      FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.fetchAndActivate();
      remoteConfig.onConfigUpdated.listen((event) async {
        await remoteConfig.activate();
        _initializeConfigValues(remoteConfig);
      });
      _initializeConfigValues(remoteConfig);
    } on FirebaseException catch (error, stackTrace) {
      CrashlyticsService.recordError(error, stackTrace);
    } catch (error, stackTrace) {
      CrashlyticsService.recordError(error, stackTrace, isFatal: true);
    }
  }

  static void _initializeConfigValues(FirebaseRemoteConfig remoteConfig) {
    try {

      RemoteConfigConstants.baseUrl = remoteConfig.getString(kBaseURLKey);
      RemoteConfigConstants.latestVersionKey = remoteConfig.getString(kLatestVersionKey);
      RemoteConfigConstants.minVersionKey = remoteConfig.getString(kMinVersionKey);
    } catch (error, stackTrace) {
      CrashlyticsService.recordError(error, stackTrace);
    }
  }
}
