import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cbyk_flutter_challenge/features/auth/domain/use_cases/login_use_case.dart';

import '../../../../support/fixtures.dart';
import '../../../../support/mocks.dart';

void main() {
  late MockAuthRepository repository;
  late LoginUseCase useCase;

  setUpAll(registerFallbackValues);

  setUp(() {
    repository = MockAuthRepository();
    useCase = LoginUseCase(repository);
  });

  test('retorna usuário autenticado', () async {
    final user = TestFixtures.user();
    final login = TestFixtures.login();

    when(
      () => repository.signInWithEmail(loginEntity: any(named: 'loginEntity')),
    ).thenAnswer((_) async => user);

    final result = await useCase(loginEntity: login);

    expect(result.id, user.id);
    verify(
      () => repository.signInWithEmail(loginEntity: login),
    ).called(1);
  });

  test('propaga erro do repositório', () async {
    when(
      () => repository.signInWithEmail(loginEntity: any(named: 'loginEntity')),
    ).thenThrow(Exception('falha'));

    expect(
      () => useCase(loginEntity: TestFixtures.login()),
      throwsA(isA<Exception>()),
    );
  });
}
