import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cbyk_flutter_challenge/features/home/presentation/widgets/home_sections.dart';
import 'package:cbyk_flutter_challenge/features/home/utils/mappers/home_page_mapper.dart';

import '../../support/pump_app.dart';

void main() {
  testWidgets('renderiza seções e callback da família', (tester) async {
    var taps = 0;

    await tester.pumpScaffold(
      SingleChildScrollView(
        child: HomeSections(onFamilyTap: () => taps++),
      ),
    );

    expect(find.text(HomePageMapper.familyTitle), findsOneWidget);
    expect(find.text(HomePageMapper.contractedTitle), findsOneWidget);
    expect(find.text(HomePageMapper.familyEmpty), findsOneWidget);

    await tester.tap(find.text(HomePageMapper.familyEmpty));
    await tester.pump();
    expect(taps, 1);
  });
}
