import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cbyk_flutter_challenge/features/register/domain/use_cases/register_use_case.dart';

import '../../../../support/fixtures.dart';
import '../../../../support/mocks.dart';

void main() {
  late MockRegisterRepository repository;
  late RegisterUseCase useCase;

  setUpAll(registerFallbackValues);

  setUp(() {
    repository = MockRegisterRepository();
    useCase = RegisterUseCase(repository);
  });

  test('cadastra usuário com sucesso', () async {
    final user = TestFixtures.user();
    final register = TestFixtures.register(name: user.name);

    when(
      () => repository.signUpWithEmail(
        registerEntity: any(named: 'registerEntity'),
      ),
    ).thenAnswer((_) async => user);

    final result = await useCase(registerEntity: register);

    expect(result.name, user.name);
    verify(
      () => repository.signUpWithEmail(registerEntity: register),
    ).called(1);
  });
}
