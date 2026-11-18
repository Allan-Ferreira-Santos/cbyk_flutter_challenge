import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cbyk_flutter_challenge/core/data/services/preferences_service.dart';
import 'package:cbyk_flutter_challenge/core/data/services/session_service.dart';

class AppModule extends Bindings {
  AppModule(this.sharedPreferences);

  final SharedPreferences sharedPreferences;

  @override
  void dependencies() {
    Get.put<SharedPreferences>(sharedPreferences, permanent: true);

    Get.put<PreferencesService>(
      PreferencesService(sharedPreferences),
      permanent: true,
    );

    Get.put<SessionService>(SessionService(), permanent: true);
  }
}
