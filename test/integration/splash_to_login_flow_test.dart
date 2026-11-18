import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cbyk_flutter_challenge/core/config/di/app_module.dart';
import 'package:cbyk_flutter_challenge/core/config/theme/app_theme.dart';
import 'package:cbyk_flutter_challenge/core/config/routes/app_pages.dart';
import 'package:cbyk_flutter_challenge/core/config/routes/app_routes_mapper.dart';
import 'package:cbyk_flutter_challenge/features/auth/utils/mappers/login_page_mapper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    setupFirebaseCoreMocks();
    await Firebase.initializeApp();
  });

  setUp(() {
    Get.reset();
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('integração: splash sem sessão navega para login', (tester) async {
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.dark,
        initialBinding: AppModule(prefs),
        initialRoute: AppRoutesMapper.splash,
        getPages: AppPages.pages,
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();

    expect(find.text(LoginPageMapper.welcomeTitle), findsOneWidget);
    expect(find.text(LoginPageMapper.tabEnter), findsOneWidget);
    expect(find.text(LoginPageMapper.socialAccess), findsOneWidget);
  });
}
