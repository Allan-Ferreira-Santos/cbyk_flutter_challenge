import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../support/firebase_core_mock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cbyk_flutter_challenge/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cbyk_flutter_challenge/core/config/theme/app_theme.dart';
import 'package:cbyk_flutter_challenge/features/auth/utils/mappers/login_page_mapper.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(setupEchoFirebaseCoreMocks);

  setUp(() {
    Get.reset();
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(Get.reset);

  testWidgets('integração: main() inicializa o app e cai no login sem sessão', (
    tester,
  ) async {
    await tester.runAsync(app.main);
    await tester.pump();

    expect(find.byType(app.CbykApp), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 1200)),
    );
    await tester.pumpAndSettle();

    expect(find.text(LoginPageMapper.welcomeTitle), findsOneWidget);
  });

  testWidgets('integração: CbykApp configura título, tema e rota inicial', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await tester.runAsync(() async {});

    await tester.pumpWidget(app.CbykApp(sharedPreferences: prefs));

    final materialApp = tester.widget<GetMaterialApp>(
      find.byType(GetMaterialApp),
    );
    expect(materialApp.title, 'CBYK Flutter Challenge');
    expect(materialApp.debugShowCheckedModeBanner, isFalse);
    expect(materialApp.theme, AppTheme.dark);
    expect(materialApp.defaultTransition, Transition.fadeIn);

    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();
  });
}
