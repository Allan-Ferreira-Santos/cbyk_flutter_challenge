import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cbyk_flutter_challenge/core/presentation/widgets/responsive_grid.dart';

import '../../support/pump_app.dart';

void main() {
  testWidgets('ResponsiveGrid renderiza filhos', (tester) async {
    await tester.pumpScaffold(
      const SizedBox(
        width: 400,
        child: ResponsiveGrid(
          children: [
            Text('A'),
            Text('B'),
            Text('C'),
          ],
        ),
      ),
    );

    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
    expect(find.text('C'), findsOneWidget);
  });

  testWidgets('ResponsiveGrid vazio não quebra', (tester) async {
    await tester.pumpScaffold(
      const ResponsiveGrid(children: []),
    );
    expect(find.byType(SizedBox), findsWidgets);
  });
}
