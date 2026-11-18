import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cbyk_flutter_challenge/core/exceptions/app_exception.dart';
import 'package:cbyk_flutter_challenge/core/helper/result_helper.dart';
import 'package:cbyk_flutter_challenge/features/home/presentation/cubit/home_cubit.dart';
import 'package:cbyk_flutter_challenge/features/home/presentation/cubit/home_state.dart';

import '../../../../support/fixtures.dart';
import '../../../../support/mocks.dart';

void main() {
  late MockGetCurrentUserUseCase getCurrentUserUseCase;
  late MockLogoutUseCase logoutUseCase;
  late HomeCubit cubit;
  final user = TestFixtures.user(name: 'Allan Ferreira');

  setUp(() {
    getCurrentUserUseCase = MockGetCurrentUserUseCase();
    logoutUseCase = MockLogoutUseCase();
    when(() => getCurrentUserUseCase()).thenReturn(user);
    cubit = HomeCubit(
      getCurrentUserUseCase: getCurrentUserUseCase,
      logoutUseCase: logoutUseCase,
    );
  });

  tearDown(() async => cubit.close());

  test('inicializa com usuário atual', () {
    expect(cubit.state.user?.name, 'Allan Ferreira');
    expect(
      cubit.state.copyWith(result: const ResultHelper.initial()).user?.name,
      'Allan Ferreira',
    );
  });

  test('load atualiza usuário', () {
    cubit.load();
    expect(cubit.state.user?.name, 'Allan Ferreira');
    expect(cubit.state.result.isError, isFalse);
  });

  test('load emite erro genérico', () {
    when(() => getCurrentUserUseCase()).thenThrow(Exception('x'));
    cubit.load();
    expect(cubit.state.result.isError, isTrue);
  });

  test('load emite erro de AppException', () {
    when(() => getCurrentUserUseCase()).thenThrow(
      const NetworkException('offline'),
    );
    cubit.load();
    expect(cubit.state.result.descriptionMessage, 'offline');
  });

  blocTest<HomeCubit, HomeState>(
    'logout emite success',
    build: () {
      when(() => logoutUseCase()).thenAnswer((_) async {});
      return cubit;
    },
    act: (cubit) => cubit.logout(),
    expect: () => [
      isA<HomeState>().having((s) => s.result.isLoading, 'loading', true),
      isA<HomeState>().having((s) => s.result.isSuccess, 'success', true),
    ],
  );

  blocTest<HomeCubit, HomeState>(
    'logout emite error',
    build: () {
      when(() => logoutUseCase()).thenThrow(const NetworkException('offline'));
      return cubit;
    },
    act: (cubit) => cubit.logout(),
    expect: () => [
      isA<HomeState>().having((s) => s.result.isLoading, 'loading', true),
      isA<HomeState>()
          .having((s) => s.result.isError, 'error', true)
          .having((s) => s.result.descriptionMessage, 'msg', 'offline'),
    ],
  );
}
