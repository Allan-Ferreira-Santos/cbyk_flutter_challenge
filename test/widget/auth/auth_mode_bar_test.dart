import 'package:flutter_test/flutter_test.dart';
import 'package:cbyk_flutter_challenge/features/auth/presentation/widgets/auth_mode_bar.dart';

import '../../support/pump_app.dart';

void main() {
  testWidgets('dispara callbacks das abas', (tester) async {
    var loginTaps = 0;
    var registerTaps = 0;

    await tester.pumpScaffold(
      AuthModeBar(
        loginSelected: true,
        loginLabel: 'Entrar',
        registerLabel: 'Cadastrar',
        onLoginTap: () => loginTaps++,
        onRegisterTap: () => registerTaps++,
      ),
    );

    await tester.tap(find.text('Cadastrar'));
    await tester.pump();
    expect(registerTaps, 1);

    await tester.tap(find.text('Entrar'));
    await tester.pump();
    expect(loginTaps, 1);
  });
}
