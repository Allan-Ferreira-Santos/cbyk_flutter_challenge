import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cbyk_flutter_challenge/core/config/routes/app_routes_mapper.dart';
import 'package:cbyk_flutter_challenge/core/config/theme/app_theme.dart';
import 'package:cbyk_flutter_challenge/core/exceptions/app_exception.dart';
import 'package:cbyk_flutter_challenge/core/utils/mappers/validate_mapper.dart';
import 'package:cbyk_flutter_challenge/features/register/presentation/cubit/register_cubit.dart';
import 'package:cbyk_flutter_challenge/features/register/presentation/pages/register_page.dart';
import 'package:cbyk_flutter_challenge/features/register/utils/mappers/register_page_mapper.dart';

import '../../support/fixtures.dart';
import '../../support/mocks.dart';
import '../../support/pump_app.dart';

void main() {
  late MockRegisterUseCase registerUseCase;
  late RegisterCubit cubit;

  setUpAll(registerFallbackValues);

  setUp(() {
    Get.reset();
    registerUseCase = MockRegisterUseCase();
    cubit = RegisterCubit(registerUseCase: registerUseCase);
    Get.put(cubit, permanent: true);
  });

  tearDown(() async {
    await cubit.close();
    Get.reset();
  });

  Future<void> pumpRegister(WidgetTester tester) async {
    tester.useViewport(const Size(800, 1600));
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.dark,
        initialRoute: AppRoutesMapper.register,
        getPages: [
          GetPage(
            name: AppRoutesMapper.register,
            page: () => const RegisterPage(),
          ),
          GetPage(
            name: AppRoutesMapper.home,
            page: () => const Scaffold(body: Text('home-screen')),
          ),
          GetPage(
            name: AppRoutesMapper.login,
            page: () => const Scaffold(body: Text('login-screen')),
          ),
        ],
      ),
    );
    await tester.pump();
  }

  Future<void> fillForm(WidgetTester tester) async {
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Allan Ferreira');
    await tester.enterText(fields.at(1), TestFixtures.validCpfDigits);
    await tester.enterText(fields.at(2), 'abcdef');
    await tester.pump();
  }

  Future<void> submitByKeyboard(WidgetTester tester) async {
    await tester.showKeyboard(find.byType(TextFormField).at(2));
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
  }

  testWidgets('formulário inválido mostra erros e não cadastra', (
    tester,
  ) async {
    await pumpRegister(tester);

    await submitByKeyboard(tester);

    expect(find.text(ValidateMapper.nameEmpty), findsOneWidget);
    expect(find.text(ValidateMapper.cpfEmpty), findsOneWidget);
    expect(find.text(ValidateMapper.passwordEmpty), findsOneWidget);
    expect(cubit.state.autovalidate, isTrue);
    verifyNever(
      () => registerUseCase(registerEntity: any(named: 'registerEntity')),
    );
  });

  testWidgets('cadastro válido navega para a home', (tester) async {
    when(
      () => registerUseCase(registerEntity: any(named: 'registerEntity')),
    ).thenAnswer((_) async => TestFixtures.user());
    await pumpRegister(tester);

    await fillForm(tester);
    await submitByKeyboard(tester);
    await tester.pumpAndSettle();

    verify(
      () => registerUseCase(registerEntity: any(named: 'registerEntity')),
    ).called(1);
    expect(find.text('home-screen'), findsOneWidget);
  });

  testWidgets('erro no cadastro exibe toast com a mensagem', (tester) async {
    when(
      () => registerUseCase(registerEntity: any(named: 'registerEntity')),
    ).thenThrow(const AlreadyExistsException('Já existe uma conta.'));
    await pumpRegister(tester);

    await fillForm(tester);
    await submitByKeyboard(tester);
    await tester.pump();

    expect(find.text(RegisterPageMapper.registerErrorTitle), findsOneWidget);
    expect(find.text('Já existe uma conta.'), findsOneWidget);
    expect(find.text('home-screen'), findsNothing);

    await tester.settleToasts();
  });

  testWidgets('aba Entrar navega para o login', (tester) async {
    await pumpRegister(tester);

    await tester.tap(find.text(RegisterPageMapper.tabEnter));
    await tester.pumpAndSettle();

    expect(find.text('login-screen'), findsOneWidget);
  });

  testWidgets('tocar na aba Cadastrar (já ativa) mantém o registro', (
    tester,
  ) async {
    await pumpRegister(tester);

    await tester.tap(find.text(RegisterPageMapper.tabRegister));
    await tester.pumpAndSettle();

    expect(find.text(RegisterPageMapper.welcomeTitle), findsOneWidget);
    expect(find.text('login-screen'), findsNothing);
  });

  testWidgets('alterna visibilidade da senha', (tester) async {
    await pumpRegister(tester);
    expect(cubit.state.obscurePassword, isTrue);

    await tester.tap(find.byIcon(Icons.visibility_outlined));
    await tester.pump();

    expect(cubit.state.obscurePassword, isFalse);
  });

  testWidgets('renderiza layout desktop', (tester) async {
    await pumpRegister(tester);
    tester.useViewport(const Size(1400, 1000));
    await tester.pump();

    expect(find.text(RegisterPageMapper.welcomeTitle), findsOneWidget);
  });
}
