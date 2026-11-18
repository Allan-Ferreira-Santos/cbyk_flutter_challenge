import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cbyk_flutter_challenge/firebase_options.dart';
import 'package:cbyk_flutter_challenge/core/config/di/app_module.dart';
import 'package:cbyk_flutter_challenge/core/config/theme/app_theme.dart';
import 'package:cbyk_flutter_challenge/core/config/routes/app_pages.dart';
import 'package:cbyk_flutter_challenge/core/config/routes/app_routes_mapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(CbykApp(sharedPreferences: prefs));
}

class CbykApp extends StatelessWidget {
  const CbykApp({super.key, required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CBYK Flutter Challenge',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      initialBinding: AppModule(sharedPreferences),
      initialRoute: AppRoutesMapper.splash,
      getPages: AppPages.pages,
      defaultTransition: Transition.fadeIn,
    );
  }
}
