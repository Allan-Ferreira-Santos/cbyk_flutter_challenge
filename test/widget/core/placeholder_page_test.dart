import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:cbyk_flutter_challenge/core/config/theme/app_theme.dart';
import 'package:cbyk_flutter_challenge/core/presentation/widgets/placeholder_page.dart';

void main() {
  setUp(() => Get.reset());
  tearDown(() => Get.reset());

  testWidgets('PlaceholderPage usa fallback sem argumentos', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.dark,
        home: const PlaceholderPage(),
      ),
    );
    expect(find.text('Em breve'), findsOneWidget);
  });

  testWidgets('PlaceholderPage usa argumento da rota', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(
          body: TextButton(
            onPressed: () => Get.to(
              () => const PlaceholderPage(),
              arguments: 'Minha conta',
            ),
            child: const Text('go'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('go'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Minha conta'), findsOneWidget);
  });
}
