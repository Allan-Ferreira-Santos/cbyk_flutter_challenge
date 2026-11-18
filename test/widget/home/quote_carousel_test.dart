import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cbyk_flutter_challenge/features/home/presentation/widgets/quote_carousel.dart';
import 'package:cbyk_flutter_challenge/features/home/utils/mappers/home_page_mapper.dart';

import '../../support/pump_app.dart';

void main() {
  testWidgets('exibe cards de cotação e dispara callbacks', (tester) async {
    var autoTaps = 0;
    String? comingSoon;

    await tester.pumpScaffold(
      QuoteCarousel(
        onAutomovel: () => autoTaps++,
        onComingSoon: (label) => comingSoon = label,
      ),
    );

    expect(find.text(HomePageMapper.auto), findsOneWidget);
    expect(find.text(HomePageMapper.residence), findsOneWidget);

    await tester.tap(find.text(HomePageMapper.auto));
    await tester.pump();
    expect(autoTaps, 1);

    await tester.tap(find.text(HomePageMapper.residence));
    await tester.pump();
    expect(comingSoon, HomePageMapper.residence);

    await tester.tap(find.text(HomePageMapper.life));
    await tester.pump();
    expect(comingSoon, HomePageMapper.life);

    await tester.tap(find.text(HomePageMapper.accidents));
    await tester.pump();
    expect(comingSoon, HomePageMapper.accidents);

    await tester.tap(find.text(HomePageMapper.moto));
    await tester.pump();
    expect(comingSoon, HomePageMapper.moto);

    await tester.tap(find.text(HomePageMapper.company));
    await tester.pump();
    expect(comingSoon, HomePageMapper.company);
  });

  testWidgets('em largura estreita permite scroll horizontal', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpScaffold(
      QuoteCarousel(
        onAutomovel: () {},
        onComingSoon: (_) {},
      ),
    );

    expect(find.text(HomePageMapper.auto), findsOneWidget);
    await tester.drag(find.byType(SingleChildScrollView), const Offset(-300, 0));
    await tester.pump();
    expect(find.text(HomePageMapper.company), findsOneWidget);
  });

  testWidgets('com enableMouseDrag aplica ScrollConfiguration', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpScaffold(
      QuoteCarousel(
        onAutomovel: () {},
        onComingSoon: (_) {},
        enableMouseDrag: true,
      ),
    );

    expect(find.byType(ScrollConfiguration), findsWidgets);
  });
}
