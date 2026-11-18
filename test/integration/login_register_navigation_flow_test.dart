import 'package:get/get.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cbyk_flutter_challenge/core/config/di/app_module.dart';
import 'package:cbyk_flutter_challenge/core/config/theme/app_theme.dart';
import 'package:cbyk_flutter_challenge/core/config/routes/app_pages.dart';
import 'package:cbyk_flutter_challenge/core/config/routes/app_routes_mapper.dart';
import 'package:cbyk_flutter_challenge/features/auth/utils/mappers/login_page_mapper.dart';
import 'package:cbyk_flutter_challenge/features/register/utils/mappers/register_page_mapper.dart';

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

  testWidgets('integração: navega entre Entrar e Cadastrar', (tester) async {
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.dark,
        initialBinding: AppModule(prefs),
        initialRoute: AppRoutesMapper.login,
        getPages: AppPages.pages,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(LoginPageMapper.welcomeTitle), findsOneWidget);

    await tester.tap(find.text(LoginPageMapper.tabRegister));
    await tester.pumpAndSettle();

    expect(find.text(RegisterPageMapper.welcomeTitle), findsOneWidget);
    expect(find.text(RegisterPageMapper.hintName), findsOneWidget);

    await tester.tap(find.text(RegisterPageMapper.tabEnter));
    await tester.pumpAndSettle();

    expect(find.text(LoginPageMapper.welcomeTitle), findsOneWidget);
  });
}
