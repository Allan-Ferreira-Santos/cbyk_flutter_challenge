import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cbyk_flutter_challenge/features/home/presentation/widgets/home_body.dart';
import 'package:cbyk_flutter_challenge/features/home/utils/mappers/home_page_mapper.dart';

import '../../support/pump_app.dart';

void main() {
  testWidgets('HomeBody renderiza banner e seções', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpApp(
      HomeBody(
        userName: 'Allan Ferreira',
        horizontalPadding: 16,
        onAutomovel: () {},
        onComingSoon: (_) {},
        onFamilyTap: () {},
      ),
    );

    expect(find.text(HomePageMapper.welcomeLabel), findsOneWidget);
    expect(find.text('Allan Ferreira'), findsOneWidget);
    expect(find.text(HomePageMapper.quoteTitle), findsOneWidget);
    expect(find.text(HomePageMapper.familyTitle), findsOneWidget);
  });
}
