import 'package:flutter_test/flutter_test.dart';
import 'package:cbyk_flutter_challenge/core/helper/result_helper.dart';
import 'package:cbyk_flutter_challenge/features/home/presentation/cubit/home_state.dart';

import '../../../../support/fixtures.dart';

void main() {
  test('HomeState inicia sem usuário e com resultado inicial', () {
    const state = HomeState();

    expect(state.user, isNull);
    expect(state.result.isLoading, isFalse);
    expect(state.result.isSuccess, isFalse);
    expect(state.result.isError, isFalse);
  });

  test('copyWith substitui user e result informados', () {
    final user = TestFixtures.user();
    final state = const HomeState().copyWith(
      user: user,
      result: ResultHelper.loading(),
    );

    expect(state.user, user);
    expect(state.result.isLoading, isTrue);
  });

  test('copyWith preserva valores quando nada é informado', () {
    final user = TestFixtures.user();
    final original = HomeState(user: user, result: ResultHelper.success());
    final copy = original.copyWith();

    expect(copy.user, user);
    expect(copy.result.isSuccess, isTrue);
  });
}
