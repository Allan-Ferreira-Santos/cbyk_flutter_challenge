import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cbyk_flutter_challenge/core/presentation/widgets/responsive_content.dart';

import '../../support/pump_app.dart';

void main() {
  testWidgets('limita a largura máxima e alinha ao topo central', (
    tester,
  ) async {
    tester.useViewport(const Size(1600, 900));
    await tester.pumpScaffold(
      const ResponsiveContent(
        maxWidth: 400,
        child: SizedBox(
          key: Key('content'),
          width: double.infinity,
          height: 50,
        ),
      ),
    );

    final size = tester.getSize(find.byKey(const Key('content')));
    expect(size.width, 400);
    expect(
      tester.getTopLeft(find.byKey(const Key('content'))).dx,
      (1600 - 400) / 2,
    );
    expect(find.byType(Padding), findsNothing);
  });

  testWidgets('aplica padding quando informado', (tester) async {
    await tester.pumpScaffold(
      const ResponsiveContent(
        padding: EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Text('conteúdo'),
      ),
    );

    final padding = tester.widget<Padding>(
      find.descendant(
        of: find.byType(ResponsiveContent),
        matching: find.byType(Padding),
      ),
    );
    expect(padding.padding, const EdgeInsets.all(16));
    expect(find.text('conteúdo'), findsOneWidget);
  });
}
