import 'package:flutter_test/flutter_test.dart';
import 'package:cbyk_flutter_challenge/features/webview/presentation/widgets/webview_error_body.dart';
import 'package:cbyk_flutter_challenge/features/webview/utils/mappers/webview_page_mapper.dart';

import '../../support/pump_app.dart';

void main() {
  testWidgets('WebViewErrorBody mostra erro e url', (tester) async {
    await tester.pumpScaffold(
      const WebViewErrorBody(
        url: 'https://example.com',
        error: 'timeout',
      ),
    );

    expect(find.text(WebViewPageMapper.loadErrorTitle), findsOneWidget);
    expect(find.textContaining('https://example.com'), findsOneWidget);
    expect(find.textContaining('timeout'), findsOneWidget);
  });
}
