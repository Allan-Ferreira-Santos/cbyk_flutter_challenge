import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cbyk_flutter_challenge/core/config/theme/app_theme.dart';
import 'package:cbyk_flutter_challenge/features/webview/presentation/cubit/webview_cubit.dart';
import 'package:cbyk_flutter_challenge/features/webview/presentation/pages/webview_page.dart';
import 'package:cbyk_flutter_challenge/features/webview/utils/mappers/webview_page_mapper.dart';

import '../../support/mocks.dart';

class MockWebViewController extends Mock implements WebViewController {}

void main() {
  late WebViewCubit cubit;
  late MockWebViewService service;

  setUpAll(registerFallbackValues);

  setUp(() {
    Get.reset();
    cubit = WebViewCubit();
    Get.put(cubit, permanent: true);
    service = MockWebViewService();
    when(() => service.hasController).thenReturn(false);
    when(() => service.reset()).thenAnswer((_) {
      when(() => service.hasController).thenReturn(false);
    });
    when(
      () => service.createController(
        url: any(named: 'url'),
        onProgress: any(named: 'onProgress'),
        onPageStarted: any(named: 'onPageStarted'),
        onPageFinished: any(named: 'onPageFinished'),
        onError: any(named: 'onError'),
      ),
    ).thenAnswer((_) {
      when(() => service.hasController).thenReturn(true);
      return MockWebViewController();
    });
    when(() => service.buildView()).thenReturn(const Text('fake-webview'));
    when(() => service.buildView(loading: any(named: 'loading')))
        .thenReturn(const Text('fake-webview'));
  });

  tearDown(() async {
    await cubit.close();
    Get.reset();
  });

  testWidgets('WebViewPage carrega argumentos e cria controller', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(
          body: TextButton(
            onPressed: () => Get.to(
              () => WebViewPage(webViewService: service),
              arguments: {
                'title': 'Automóvel',
                'url': 'https://example.com',
              },
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Automóvel'), findsOneWidget);
    expect(find.text('fake-webview'), findsOneWidget);
    verify(
      () => service.createController(
        url: 'https://example.com',
        onProgress: any(named: 'onProgress'),
        onPageStarted: any(named: 'onPageStarted'),
        onPageFinished: any(named: 'onPageFinished'),
        onError: any(named: 'onError'),
      ),
    ).called(greaterThan(0));
  });

  testWidgets('WebViewPage usa defaults sem argumentos', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.dark,
        home: WebViewPage(webViewService: service),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text(WebViewPageMapper.defaultTitle), findsOneWidget);
  });

  testWidgets('WebViewPage mostra erro', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.dark,
        home: WebViewPage(webViewService: service),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    cubit.onWebResourceError('falhou');
    await tester.pump();

    expect(find.textContaining('falhou'), findsOneWidget);
  });

  testWidgets('WebViewPage com forceWebBehavior finaliza loading', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.dark,
        home: WebViewPage(
          webViewService: service,
          forceWebBehavior: true,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(cubit.state.isPageLoading, isFalse);
    expect(find.byType(LinearProgressIndicator), findsNothing);
  });

  testWidgets('WebViewPage listener cobre reload loading e success', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.dark,
        home: WebViewPage(webViewService: service),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('fake-webview'), findsOneWidget);

    cubit.load(title: 'Reload', url: 'https://example.com/reload');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    verify(() => service.reset()).called(greaterThan(0));
    expect(find.text('Reload'), findsOneWidget);
    expect(find.text('fake-webview'), findsOneWidget);
  });
}
