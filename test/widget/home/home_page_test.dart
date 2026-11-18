import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cbyk_flutter_challenge/core/config/routes/app_routes_mapper.dart';
import 'package:cbyk_flutter_challenge/core/config/theme/app_theme.dart';
import 'package:cbyk_flutter_challenge/core/exceptions/app_exception.dart';
import 'package:cbyk_flutter_challenge/features/home/presentation/cubit/home_cubit.dart';
import 'package:cbyk_flutter_challenge/features/home/presentation/pages/home_page.dart';
import 'package:cbyk_flutter_challenge/features/home/presentation/widgets/notification_button.dart';
import 'package:cbyk_flutter_challenge/features/home/utils/mappers/home_page_mapper.dart';
import 'package:cbyk_flutter_challenge/features/webview/presentation/cubit/webview_cubit.dart';
import 'package:cbyk_flutter_challenge/features/webview/presentation/pages/webview_page.dart';

import '../../support/fixtures.dart';
import '../../support/mocks.dart';

class MockWebViewController extends Mock implements WebViewController {}

void main() {
  late MockGetCurrentUserUseCase getCurrentUser;
  late MockLogoutUseCase logout;
  late HomeCubit cubit;
  late MockWebViewService webViewService;

  setUpAll(registerFallbackValues);

  setUp(() {
    Get.reset();
    getCurrentUser = MockGetCurrentUserUseCase();
    logout = MockLogoutUseCase();
    webViewService = MockWebViewService();
    when(() => getCurrentUser()).thenReturn(TestFixtures.user(name: 'Allan'));
    when(() => webViewService.hasController).thenReturn(false);
    when(() => webViewService.reset()).thenReturn(null);
    when(
      () => webViewService.createController(
        url: any(named: 'url'),
        onProgress: any(named: 'onProgress'),
        onPageStarted: any(named: 'onPageStarted'),
        onPageFinished: any(named: 'onPageFinished'),
        onError: any(named: 'onError'),
      ),
    ).thenAnswer((_) {
      when(() => webViewService.hasController).thenReturn(true);
      return MockWebViewController();
    });
    when(() => webViewService.buildView()).thenReturn(const Text('fake-webview'));
    when(() => webViewService.buildView(loading: any(named: 'loading')))
        .thenReturn(const Text('fake-webview'));

    cubit = HomeCubit(
      getCurrentUserUseCase: getCurrentUser,
      logoutUseCase: logout,
    );
    Get.put(cubit, permanent: true);
    Get.put(WebViewCubit(), permanent: true);
  });

  tearDown(() async {
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }
    await cubit.close();
    Get.reset();
  });

  Future<void> pumpHome(WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.dark,
        initialRoute: AppRoutesMapper.home,
        getPages: [
          GetPage(
            name: AppRoutesMapper.home,
            page: () => const HomePage(),
          ),
          GetPage(
            name: AppRoutesMapper.webview,
            page: () => WebViewPage(webViewService: webViewService),
          ),
          GetPage(
            name: AppRoutesMapper.login,
            page: () => const Scaffold(body: Text('login-screen')),
          ),
        ],
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('HomePage renderiza usuário e abre drawer', (tester) async {
    await pumpHome(tester);

    expect(find.text('Tokio Marine Seguradora'), findsOneWidget);
    expect(find.textContaining('Allan'), findsWidgets);

    await tester.tap(find.byTooltip('Menu'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('ALLAN'), findsOneWidget);
  });

  testWidgets('HomePage navega para webview no Automóvel', (tester) async {
    await pumpHome(tester);

    await tester.tap(find.text(HomePageMapper.auto));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(Get.currentRoute, AppRoutesMapper.webview);
    expect(find.text('fake-webview'), findsOneWidget);
  });

  testWidgets('HomePage logout sucesso redireciona login', (tester) async {
    when(() => logout()).thenAnswer((_) async {});
    await pumpHome(tester);

    await tester.tap(find.byTooltip('Menu'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.dragUntilVisible(
      find.text('Sair'),
      find.byType(ListView),
      const Offset(0, -80),
    );
    await tester.tap(find.text('Sair'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('login-screen'), findsOneWidget);
  });

  testWidgets('HomePage dispara coming soon na notificação', (tester) async {
    await pumpHome(tester);

    await tester.tap(find.byType(NotificationButton));
    await tester.pump();
    expect(find.textContaining(HomePageMapper.comingSoon), findsOneWidget);

    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }
    await tester.pump(const Duration(milliseconds: 400));
  });

  testWidgets('HomePage dispara coming soon ao tocar em família', (tester) async {
    await pumpHome(tester);

    await tester.tap(find.text(HomePageMapper.familyEmpty));
    await tester.pump();
    expect(find.textContaining(HomePageMapper.comingSoon), findsOneWidget);

    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }
    await tester.pump(const Duration(milliseconds: 400));
  });

  testWidgets('HomePage mostra toast em erro de logout', (tester) async {
    when(() => logout()).thenThrow(const NetworkException('offline'));
    await pumpHome(tester);

    await tester.tap(find.byTooltip('Menu'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.dragUntilVisible(
      find.text('Sair'),
      find.byType(ListView),
      const Offset(0, -80),
    );
    await tester.tap(find.text('Sair'));
    await tester.pump();
    expect(find.textContaining('offline'), findsOneWidget);

    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }
    await tester.pump(const Duration(milliseconds: 400));
  });
}
