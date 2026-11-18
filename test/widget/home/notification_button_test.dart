import 'package:flutter_test/flutter_test.dart';
import 'package:cbyk_flutter_challenge/features/home/presentation/widgets/notification_button.dart';

import '../../support/pump_app.dart';

void main() {
  testWidgets('NotificationButton dispara onPressed', (tester) async {
    var taps = 0;
    await tester.pumpScaffold(
      NotificationButton(onPressed: () => taps++),
    );

    await tester.tap(find.byType(NotificationButton));
    await tester.pump();
    expect(taps, 1);
  });
}
