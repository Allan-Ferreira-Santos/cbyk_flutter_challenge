import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cbyk_flutter_challenge/features/home/domain/use_cases/get_current_user_use_case.dart';
import 'package:cbyk_flutter_challenge/features/home/domain/use_cases/logout_use_case.dart';

import '../../../../support/fixtures.dart';
import '../../../../support/mocks.dart';

void main() {
  late MockHomeRepository repository;

  setUp(() {
    repository = MockHomeRepository();
  });

  test('GetCurrentUserUseCase retorna usuário', () {
    final user = TestFixtures.user();
    when(() => repository.getCurrentUser()).thenReturn(user);

    final result = GetCurrentUserUseCase(repository)();
    expect(result?.id, user.id);
  });

  test('LogoutUseCase chama repositório', () async {
    when(() => repository.logout()).thenAnswer((_) async {});

    await LogoutUseCase(repository)();
    verify(() => repository.logout()).called(1);
  });
}
