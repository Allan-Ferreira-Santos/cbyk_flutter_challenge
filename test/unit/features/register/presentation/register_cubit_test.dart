import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cbyk_flutter_challenge/core/exceptions/app_exception.dart';
import 'package:cbyk_flutter_challenge/features/register/presentation/cubit/register_cubit.dart';
import 'package:cbyk_flutter_challenge/features/register/presentation/cubit/register_state.dart';
import 'package:cbyk_flutter_challenge/features/register/utils/mappers/register_page_mapper.dart';

import '../../../../support/fixtures.dart';
import '../../../../support/mocks.dart';

void main() {
  late MockRegisterUseCase registerUseCase;
  late RegisterCubit cubit;

  setUpAll(registerFallbackValues);

  setUp(() {
    registerUseCase = MockRegisterUseCase();
    cubit = RegisterCubit(registerUseCase: registerUseCase);
  });

  tearDown(() async => cubit.close());

  test('atualiza campos e obscurePassword', () {
    cubit
      ..onNameChanged('Allan')
      ..onCpfChanged(TestFixtures.validCpfMasked)
      ..onPasswordChanged('abcdef')
      ..toggleObscurePassword()
      ..enableAutovalidate();

    expect(cubit.state.name, 'Allan');
    expect(cubit.state.cpf, TestFixtures.validCpfMasked);
    expect(cubit.state.password, 'abcdef');
    expect(cubit.state.obscurePassword, isFalse);
    expect(cubit.state.autovalidate, isTrue);
  });

  blocTest<RegisterCubit, RegisterState>(
    'register emite success',
    build: () {
      when(
        () => registerUseCase(registerEntity: any(named: 'registerEntity')),
      ).thenAnswer((_) async => TestFixtures.user(name: 'Allan'));
      return cubit
        ..onNameChanged('Allan')
        ..onCpfChanged(TestFixtures.validCpfMasked)
        ..onPasswordChanged('abcdef');
    },
    act: (cubit) => cubit.register(),
    expect: () => [
      isA<RegisterState>()
          .having((s) => s.submitResult.isLoading, 'loading', true),
      isA<RegisterState>()
          .having((s) => s.submitResult.isSuccess, 'success', true)
          .having(
            (s) => s.submitResult.titleMessage,
            'title',
            RegisterPageMapper.registerSuccess,
          ),
    ],
  );

  blocTest<RegisterCubit, RegisterState>(
    'register emite error',
    build: () {
      when(
        () => registerUseCase(registerEntity: any(named: 'registerEntity')),
      ).thenThrow(const AlreadyExistsException('existe'));
      return cubit
        ..onNameChanged('Allan')
        ..onCpfChanged(TestFixtures.validCpfMasked)
        ..onPasswordChanged('abcdef');
    },
    act: (cubit) => cubit.register(),
    expect: () => [
      isA<RegisterState>()
          .having((s) => s.submitResult.isLoading, 'loading', true),
      isA<RegisterState>()
          .having((s) => s.submitResult.isError, 'error', true)
          .having(
            (s) => s.submitResult.descriptionMessage,
            'description',
            'existe',
          ),
    ],
  );
}
