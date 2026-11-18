import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cbyk_flutter_challenge/core/exceptions/app_exception.dart';
import 'package:cbyk_flutter_challenge/core/helper/mask_input_helper.dart';
import 'package:cbyk_flutter_challenge/features/auth/presentation/cubit/login_cubit.dart';
import 'package:cbyk_flutter_challenge/features/auth/presentation/cubit/login_state.dart';
import 'package:cbyk_flutter_challenge/features/auth/utils/mappers/login_page_mapper.dart';

import '../../../../support/fixtures.dart';
import '../../../../support/mocks.dart';

void main() {
  late MockLoginUseCase loginUseCase;
  late MockLoginWithGoogleUseCase googleUseCase;
  late MockPreferencesService preferences;
  late LoginCubit cubit;

  setUpAll(registerFallbackValues);

  setUp(() {
    loginUseCase = MockLoginUseCase();
    googleUseCase = MockLoginWithGoogleUseCase();
    preferences = MockPreferencesService();
    cubit = LoginCubit(
      loginUseCase: loginUseCase,
      loginWithGoogleUseCase: googleUseCase,
      preferencesService: preferences,
    );
  });

  tearDown(() async => cubit.close());

  test('estado inicial', () {
    expect(cubit.state.cpf, '');
    expect(cubit.state.obscurePassword, isTrue);
    expect(cubit.state.submitResult.isLoading, isFalse);
  });

  test('loadSavedPreferences preenche CPF lembrado', () {
    when(() => preferences.rememberAlways).thenReturn(true);
    when(() => preferences.savedCpf).thenReturn(TestFixtures.validCpfDigits);

    cubit.loadSavedPreferences();

    expect(cubit.state.rememberAlways, isTrue);
    expect(cubit.state.cpf, TestFixtures.validCpfMasked);
  });

  test('togglers e inputs atualizam estado', () {
    cubit
      ..onCpfChanged(TestFixtures.validCpfMasked)
      ..onPasswordChanged('123456')
      ..toggleRememberAlways(true)
      ..toggleObscurePassword()
      ..enableAutovalidate();

    expect(cubit.state.cpf, TestFixtures.validCpfMasked);
    expect(cubit.state.password, '123456');
    expect(cubit.state.rememberAlways, isTrue);
    expect(cubit.state.obscurePassword, isFalse);
    expect(cubit.state.autovalidate, isTrue);

    cubit.enableAutovalidate();
    expect(cubit.state.autovalidate, isTrue);
  });

  blocTest<LoginCubit, LoginState>(
    'login emite loading e success',
    build: () {
      final user = TestFixtures.user();
      when(
        () => loginUseCase(loginEntity: any(named: 'loginEntity')),
      ).thenAnswer((_) async => user);
      when(() => preferences.setRememberAlways(any())).thenAnswer((_) async {});
      when(() => preferences.setSavedCpf(any())).thenAnswer((_) async {});
      return cubit
        ..onCpfChanged(TestFixtures.validCpfMasked)
        ..onPasswordChanged('123456')
        ..toggleRememberAlways(true);
    },
    act: (cubit) => cubit.login(),
    expect: () => [
      isA<LoginState>().having((s) => s.submitResult.isLoading, 'loading', true),
      isA<LoginState>().having((s) => s.submitResult.isSuccess, 'success', true),
    ],
    verify: (_) {
      verify(
        () => preferences.setSavedCpf(
          MaskInputHelper.unmaskCpf(TestFixtures.validCpfMasked),
        ),
      ).called(1);
    },
  );

  blocTest<LoginCubit, LoginState>(
    'login emite error em falha',
    build: () {
      when(
        () => loginUseCase(loginEntity: any(named: 'loginEntity')),
      ).thenThrow(const UnauthorizedException('inválido'));
      when(() => preferences.setRememberAlways(any())).thenAnswer((_) async {});
      when(() => preferences.setSavedCpf(any())).thenAnswer((_) async {});
      return cubit
        ..onCpfChanged(TestFixtures.validCpfMasked)
        ..onPasswordChanged('fail');
    },
    act: (cubit) => cubit.login(),
    expect: () => [
      isA<LoginState>().having((s) => s.submitResult.isLoading, 'loading', true),
      isA<LoginState>()
          .having((s) => s.submitResult.isError, 'error', true)
          .having(
            (s) => s.submitResult.titleMessage,
            'title',
            LoginPageMapper.loginErrorTitle,
          )
          .having(
            (s) => s.submitResult.descriptionMessage,
            'description',
            'inválido',
          ),
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'loginWithGoogle emite success',
    build: () {
      when(() => googleUseCase()).thenAnswer((_) async => TestFixtures.user());
      return cubit;
    },
    act: (cubit) => cubit.loginWithGoogle(),
    expect: () => [
      isA<LoginState>().having((s) => s.submitResult.isLoading, 'loading', true),
      isA<LoginState>().having((s) => s.submitResult.isSuccess, 'success', true),
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'loginWithGoogle emite error',
    build: () {
      when(() => googleUseCase()).thenThrow(Exception('google'));
      return cubit;
    },
    act: (cubit) => cubit.loginWithGoogle(),
    expect: () => [
      isA<LoginState>().having((s) => s.submitResult.isLoading, 'loading', true),
      isA<LoginState>()
          .having((s) => s.submitResult.isError, 'error', true)
          .having(
            (s) => s.submitResult.titleMessage,
            'title',
            LoginPageMapper.googleErrorTitle,
          ),
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'login sem remember limpa CPF salvo',
    build: () {
      when(
        () => loginUseCase(loginEntity: any(named: 'loginEntity')),
      ).thenAnswer((_) async => TestFixtures.user());
      when(() => preferences.setRememberAlways(any())).thenAnswer((_) async {});
      when(() => preferences.setSavedCpf(any())).thenAnswer((_) async {});
      return cubit
        ..onCpfChanged(TestFixtures.validCpfMasked)
        ..onPasswordChanged('123456')
        ..toggleRememberAlways(false);
    },
    act: (cubit) => cubit.login(),
    expect: () => [
      isA<LoginState>().having((s) => s.submitResult.isLoading, 'loading', true),
      isA<LoginState>().having((s) => s.submitResult.isSuccess, 'success', true),
    ],
    verify: (_) {
      verify(() => preferences.setSavedCpf(null)).called(1);
    },
  );
}
