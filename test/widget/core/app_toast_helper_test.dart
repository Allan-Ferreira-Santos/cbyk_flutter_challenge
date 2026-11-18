import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:cbyk_flutter_challenge/core/config/theme/app_theme.dart';
import 'package:cbyk_flutter_challenge/core/helper/app_toast_helper.dart';

void main() {
  setUp(() => Get.reset());

  testWidgets('show exibe snackbar, debounce e substitui mensagem diferente', (
    tester,
  ) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return Column(
                children: [
                  TextButton(
                    onPressed: () => AppToastHelper.show('Título', 'Mensagem'),
                    child: const Text('toast-a'),
                  ),
                  TextButton(
                    onPressed: () => AppToastHelper.show('Outro', 'Nova'),
                    child: const Text('toast-b'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('toast-a'));
    await tester.pump();
    expect(find.text('Título'), findsOneWidget);

    await tester.tap(find.text('toast-a'));
    await tester.pump();
    expect(find.text('Título'), findsOneWidget);

    await tester.tap(find.text('toast-b'));
    await tester.pump();
    expect(find.text('Outro'), findsOneWidget);
    expect(find.text('Nova'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pump(const Duration(milliseconds: 500));
  });
}
