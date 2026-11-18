import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:cbyk_flutter_challenge/core/config/routes/app_routes_mapper.dart';
import 'package:cbyk_flutter_challenge/core/config/theme/app_theme.dart';
import 'package:cbyk_flutter_challenge/core/presentation/widgets/drawer/app_drawer.dart';
import 'package:cbyk_flutter_challenge/core/presentation/widgets/drawer/drawer_mapper.dart';
import 'package:cbyk_flutter_challenge/core/presentation/widgets/placeholder_page.dart';

import '../../support/fixtures.dart';

void main() {
  setUp(() => Get.reset());
  tearDown(() => Get.reset());

  testWidgets('AppDrawer mostra usuário e logout', (tester) async {
    var logout = 0;
    final user = TestFixtures.user(name: 'Allan Ferreira');

    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(
          drawer: AppDrawer(user: user, onLogout: () async => logout++),
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('ALLAN FERREIRA'), findsOneWidget);
    expect(find.text(DrawerMapper.menuHome), findsOneWidget);
    expect(find.text(DrawerMapper.helpTitle), findsOneWidget);

    await tester.dragUntilVisible(
      find.text(DrawerMapper.logout),
      find.byType(ListView),
      const Offset(0, -80),
    );
    await tester.tap(find.text(DrawerMapper.logout));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(logout, 1);
  });

  testWidgets('AppDrawer abre placeholders do menu', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.dark,
        initialRoute: '/home',
        getPages: [
          GetPage(
            name: '/home',
            page: () => Scaffold(
              drawer: AppDrawer(
                user: null,
                onLogout: () async {},
              ),
              body: Builder(
                builder: (context) => TextButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
          GetPage(
            name: AppRoutesMapper.placeholder,
            page: () => const PlaceholderPage(),
          ),
        ],
      ),
    );

    Future<void> openDrawer() async {
      await tester.tap(find.text('open'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
    }

    Future<void> tapMenuAndExpectPlaceholder(String label) async {
      await openDrawer();
      await tester.dragUntilVisible(
        find.text(label),
        find.byType(ListView),
        const Offset(0, -80),
      );
      await tester.tap(find.text(label));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(Get.currentRoute, AppRoutesMapper.placeholder);
      expect(find.text(label), findsWidgets);
      Get.back();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
    }

    await openDrawer();
    expect(find.text(DrawerMapper.defaultUserName), findsOneWidget);

    await tester.tap(find.text(DrawerMapper.menuHome));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(Get.currentRoute, '/home');

    await tapMenuAndExpectPlaceholder(DrawerMapper.menuContracts);
    await tapMenuAndExpectPlaceholder(DrawerMapper.menuClaims);
    await tapMenuAndExpectPlaceholder(DrawerMapper.menuFamily);
    await tapMenuAndExpectPlaceholder(DrawerMapper.menuAssets);
    await tapMenuAndExpectPlaceholder(DrawerMapper.menuPayments);
    await tapMenuAndExpectPlaceholder(DrawerMapper.menuCoverage);
    await tapMenuAndExpectPlaceholder(DrawerMapper.menuValidateSlip);
    await tapMenuAndExpectPlaceholder(DrawerMapper.menuPhones);
    await tapMenuAndExpectPlaceholder(DrawerMapper.menuSettings);

    await openDrawer();
    await tester.tap(find.text(DrawerMapper.myAccount));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(Get.currentRoute, AppRoutesMapper.placeholder);
    expect(find.text(DrawerMapper.myAccount), findsWidgets);
  });
}
