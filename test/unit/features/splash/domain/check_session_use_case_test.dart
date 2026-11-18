import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cbyk_flutter_challenge/features/splash/domain/use_cases/check_session_use_case.dart';

import '../../../../support/fixtures.dart';
import '../../../../support/mocks.dart';

void main() {
  late MockSplashRepository repository;
  late CheckSessionUseCase useCase;

  setUp(() {
    repository = MockSplashRepository();
    useCase = CheckSessionUseCase(repository);
  });

  test('retorna usuário quando sessão existe', () async {
    final user = TestFixtures.user();
    when(() => repository.getCurrentUser()).thenAnswer((_) async => user);

    final result = await useCase();
    expect(result?.email, user.email);
  });

  test('retorna null sem sessão', () async {
    when(() => repository.getCurrentUser()).thenAnswer((_) async => null);

    final result = await useCase();
    expect(result, isNull);
  });
}
