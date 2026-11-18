import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cbyk_flutter_challenge/core/presentation/widgets/empty_dashed_card.dart';

import '../../support/pump_app.dart';

void main() {
  testWidgets('exibe ícone, mensagem e onTap', (tester) async {
    var taps = 0;

    await tester.pumpScaffold(
      EmptyDashedCard(
        icon: Icons.add,
        message: 'Mensagem vazia',
        onTap: () => taps++,
      ),
    );

    expect(find.text('Mensagem vazia'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(find.text('Mensagem vazia'));
    await tester.pump();
    expect(taps, 1);
  });
}
