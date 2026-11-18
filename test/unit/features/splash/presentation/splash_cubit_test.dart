import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cbyk_flutter_challenge/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:cbyk_flutter_challenge/features/splash/presentation/cubit/splash_state.dart';

import '../../../../support/fixtures.dart';
import '../../../../support/mocks.dart';

void main() {
  late MockCheckSessionUseCase checkSessionUseCase;

  setUp(() {
    checkSessionUseCase = MockCheckSessionUseCase();
  });

  blocTest<SplashCubit, SplashState>(
    'checkSession autentica quando há usuário',
    build: () {
      when(() => checkSessionUseCase())
          .thenAnswer((_) async => TestFixtures.user());
      return SplashCubit(checkSessionUseCase);
    },
    act: (cubit) => cubit.checkSession(),
    wait: const Duration(milliseconds: 850),
    expect: () => [
      isA<SplashState>().having((s) => s.isAuthenticated, 'auth', true),
    ],
  );

  blocTest<SplashCubit, SplashState>(
    'checkSession não autentica sem usuário',
    build: () {
      when(() => checkSessionUseCase()).thenAnswer((_) async => null);
      return SplashCubit(checkSessionUseCase);
    },
    act: (cubit) => cubit.checkSession(),
    wait: const Duration(milliseconds: 850),
    expect: () => [
      isA<SplashState>().having((s) => s.isAuthenticated, 'auth', false),
    ],
  );
}
