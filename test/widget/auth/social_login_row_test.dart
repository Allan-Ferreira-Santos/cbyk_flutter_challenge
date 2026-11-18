import 'package:flutter_test/flutter_test.dart';
import 'package:cbyk_flutter_challenge/features/auth/presentation/widgets/social_login_row.dart';

import '../../support/pump_app.dart';

void main() {
  testWidgets('dispara callbacks sociais quando habilitado', (tester) async {
    var google = 0;
    var facebook = 0;
    var twitter = 0;

    await tester.pumpScaffold(
      SocialLoginRow(
        onGooglePressed: () => google++,
        onFacebookPressed: () => facebook++,
        onTwitterPressed: () => twitter++,
      ),
    );

    await tester.tap(find.byTooltip('Google'));
    await tester.tap(find.byTooltip('Facebook'));
    await tester.tap(find.byTooltip('Twitter'));
    await tester.pump();

    expect(google, 1);
    expect(facebook, 1);
    expect(twitter, 1);
  });

  testWidgets('não dispara quando desabilitado', (tester) async {
    var google = 0;

    await tester.pumpScaffold(
      SocialLoginRow(
        enabled: false,
        onGooglePressed: () => google++,
      ),
    );

    await tester.tap(find.byTooltip('Google'));
    await tester.pump();
    expect(google, 0);
  });
}
