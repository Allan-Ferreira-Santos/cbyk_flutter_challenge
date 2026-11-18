import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:cbyk_flutter_challenge/core/helper/mask_input_helper.dart';
import 'package:cbyk_flutter_challenge/features/auth/presentation/widgets/login_card.dart';
import 'package:cbyk_flutter_challenge/features/auth/utils/mappers/login_page_mapper.dart';

import '../../support/pump_app.dart';

void main() {
  testWidgets('renderiza campos e ações do login', (tester) async {
    final formKey = GlobalKey<FormState>();
    final cpfController = TextEditingController();
    final passwordController = TextEditingController();
    final MaskTextInputFormatter cpfMask =
        MaskInputHelper.cpfMaskWithInitial(null);

    var remember = false;

    await tester.pumpScaffold(
      SingleChildScrollView(
        child: LoginCard(
          formKey: formKey,
          cpfController: cpfController,
          passwordController: passwordController,
          cpfMask: cpfMask,
          obscurePassword: true,
          rememberAlways: remember,
          autovalidate: false,
          isLoading: false,
          onCpfChanged: (_) {},
          onPasswordChanged: (_) {},
          onToggleObscurePassword: () {},
          onToggleRememberAlways: (value) => remember = value ?? false,
          onSubmit: () {},
        ),
      ),
    );

    expect(find.text(LoginPageMapper.tabEnter), findsOneWidget);
    expect(find.text(LoginPageMapper.rememberAlways), findsOneWidget);
    expect(find.text(LoginPageMapper.forgotPassword), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));

    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(remember, isTrue);
  });
}
