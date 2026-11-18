import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:cbyk_flutter_challenge/features/webview/data/services/webview_service.dart';

import '../../../../support/fake_webview_platform.dart';

void main() {
  setUp(() {
    WebViewPlatform.instance = FakeWebViewPlatform();
  });

  testWidgets('buildView sem controller mostra loading', (tester) async {
    final service = WebViewService();
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: service.buildView())),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(service.hasController, isFalse);
  });

  testWidgets('createController e buildView com controller', (tester) async {
    final service = WebViewService();

    service.createController(
      url: 'https://example.com',
      onProgress: (_) {},
      onPageStarted: () {},
      onPageFinished: () {},
      onError: (_) {},
    );

    expect(service.hasController, isTrue);
    expect(service.controller, isNotNull);

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: service.buildView())),
    );
    expect(find.byKey(const Key('fake-wv')), findsOneWidget);

    service.reset();
    expect(service.hasController, isFalse);
  });
}
