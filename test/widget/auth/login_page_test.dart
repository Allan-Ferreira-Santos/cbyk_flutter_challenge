import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cbyk_flutter_challenge/core/config/routes/app_routes_mapper.dart';
import 'package:cbyk_flutter_challenge/core/config/theme/app_theme.dart';
import 'package:cbyk_flutter_challenge/core/exceptions/app_exception.dart';
import 'package:cbyk_flutter_challenge/core/utils/mappers/validate_mapper.dart';
import 'package:cbyk_flutter_challenge/features/auth/presentation/cubit/login_cubit.dart';
import 'package:cbyk_flutter_challenge/features/auth/presentation/pages/login_page.dart';
import 'package:cbyk_flutter_challenge/features/auth/utils/mappers/login_page_mapper.dart';

import '../../support/fixtures.dart';
import '../../support/mocks.dart';
import '../../support/pump_app.dart';

void main() {
  late MockLoginUseCase loginUseCase;
  late MockLoginWithGoogleUseCase googleUseCase;
  late MockPreferencesService preferences;
  late LoginCubit cubit;

  setUpAll(registerFallbackValues);

  setUp(() {
    Get.reset();
    loginUseCase = MockLoginUseCase();
    googleUseCase = MockLoginWithGoogleUseCase();
    preferences = MockPreferencesService();
    when(() => preferences.rememberAlways).thenReturn(false);
    when(() => preferences.savedCpf).thenReturn(null);
    when(() => preferences.setRememberAlways(any())).thenAnswer((_) async {});
    when(() => preferences.setSavedCpf(any())).thenAnswer((_) async {});

    cubit = LoginCubit(
      loginUseCase: loginUseCase,
      loginWithGoogleUseCase: googleUseCase,
      preferencesService: preferences,
    );
    Get.put(cubit, permanent: true);
  });

  tearDown(() async {
    await cubit.close();
    Get.reset();
  });

  Future<void> pumpLogin(WidgetTester tester) async {
    tester.useViewport(const Size(800, 1600));
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.dark,
        initialRoute: AppRoutesMapper.login,
        getPages: [
          GetPage(name: AppRoutesMapper.login, page: () => const LoginPage()),
          GetPage(
            name: AppRoutesMapper.home,
            page: () => const Scaffold(body: Text('home-screen')),
          ),
          GetPage(
            name: AppRoutesMapper.register,
            page: () => const Scaffold(body: Text('register-screen')),
          ),
        ],
      ),
    );
    await tester.pump();
  }

  Future<void> fillForm(WidgetTester tester) async {
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), TestFixtures.validCpfDigits);
    await tester.enterText(fields.at(1), 'abcdef');
    await tester.pump();
  }

  Future<void> submitByKeyboard(WidgetTester tester) async {
    await tester.showKeyboard(find.byType(TextFormField).at(1));
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
  }

  testWidgets('formulário inválido mostra erros e não chama o login', (
    tester,
  ) async {
    await pumpLogin(tester);

    await submitByKeyboard(tester);

    expect(find.text(ValidateMapper.cpfEmpty), findsOneWidget);
    expect(find.text(ValidateMapper.passwordEmpty), findsOneWidget);
    expect(cubit.state.autovalidate, isTrue);
    verifyNever(() => loginUseCase(loginEntity: any(named: 'loginEntity')));
  });

  testWidgets('login válido envia credenciais e navega para a home', (
    tester,
  ) async {
    when(
      () => loginUseCase(loginEntity: any(named: 'loginEntity')),
    ).thenAnswer((_) async => TestFixtures.user());
    await pumpLogin(tester);

    await fillForm(tester);
    await submitByKeyboard(tester);
    await tester.pumpAndSettle();

    verify(
      () => loginUseCase(loginEntity: any(named: 'loginEntity')),
    ).called(1);
    expect(find.text('home-screen'), findsOneWidget);
  });

  testWidgets('erro no login exibe toast com a mensagem', (tester) async {
    when(
      () => loginUseCase(loginEntity: any(named: 'loginEntity')),
    ).thenThrow(const UnauthorizedException('CPF ou senha inválidos.'));
    await pumpLogin(tester);

    await fillForm(tester);
    await submitByKeyboard(tester);
    await tester.pump();

    expect(find.text(LoginPageMapper.loginErrorTitle), findsOneWidget);
    expect(find.text('CPF ou senha inválidos.'), findsOneWidget);
    expect(find.text('home-screen'), findsNothing);

    await tester.settleToasts();
  });

  testWidgets('botão Google dispara login social e navega para a home', (
    tester,
  ) async {
    when(() => googleUseCase()).thenAnswer((_) async => TestFixtures.user());
    await pumpLogin(tester);

    await tester.tap(find.byTooltip('Google'));
    await tester.pumpAndSettle();

    verify(() => googleUseCase()).called(1);
    expect(find.text('home-screen'), findsOneWidget);
  });

  testWidgets('Facebook mostra aviso de em breve', (tester) async {
    await pumpLogin(tester);

    await tester.tap(find.byTooltip('Facebook'));
    await tester.pump();

    expect(find.text('Facebook'), findsWidgets);
    expect(find.text(LoginPageMapper.socialComingSoon), findsOneWidget);
    await tester.settleToasts();
  });

  testWidgets('Twitter mostra aviso de em breve', (tester) async {
    await pumpLogin(tester);

    await tester.tap(find.byTooltip('Twitter'));
    await tester.pump();

    expect(find.text('Twitter'), findsWidgets);
    expect(find.text(LoginPageMapper.socialComingSoon), findsOneWidget);
    await tester.settleToasts();
  });

  testWidgets('Esqueceu a senha mostra aviso de em breve', (tester) async {
    await pumpLogin(tester);

    await tester.tap(find.text(LoginPageMapper.forgotPassword));
    await tester.pump();

    expect(find.text(LoginPageMapper.forgotPasswordSnack), findsOneWidget);
    await tester.settleToasts();
  });

  testWidgets('aba Cadastrar navega para o registro', (tester) async {
    await pumpLogin(tester);

    await tester.tap(find.text(LoginPageMapper.tabRegister));
    await tester.pumpAndSettle();

    expect(find.text('register-screen'), findsOneWidget);
  });

  testWidgets('tocar na aba Entrar (já ativa) mantém o login', (tester) async {
    await pumpLogin(tester);

    await tester.tap(find.text(LoginPageMapper.tabEnter));
    await tester.pumpAndSettle();

    expect(find.text(LoginPageMapper.welcomeTitle), findsOneWidget);
    expect(find.text('register-screen'), findsNothing);
  });

  testWidgets('preenche o CPF salvo quando lembrar sempre está ativo', (
    tester,
  ) async {
    when(() => preferences.rememberAlways).thenReturn(true);
    when(() => preferences.savedCpf).thenReturn(TestFixtures.validCpfDigits);
    await pumpLogin(tester);

    expect(find.text(TestFixtures.validCpfMasked), findsOneWidget);
    expect(cubit.state.rememberAlways, isTrue);
  });

  testWidgets('renderiza layout desktop centralizado', (tester) async {
    await pumpLogin(tester);
    tester.useViewport(const Size(1400, 1000));
    await tester.pump();

    expect(find.text(LoginPageMapper.welcomeTitle), findsOneWidget);
    expect(find.text(LoginPageMapper.socialAccess), findsOneWidget);
  });
}
