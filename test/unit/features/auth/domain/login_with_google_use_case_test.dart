import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cbyk_flutter_challenge/features/auth/domain/use_cases/login_with_google_use_case.dart';

import '../../../../support/fixtures.dart';
import '../../../../support/mocks.dart';

void main() {
  late MockAuthRepository repository;
  late LoginWithGoogleUseCase useCase;

  setUpAll(registerFallbackValues);

  setUp(() {
    repository = MockAuthRepository();
    useCase = LoginWithGoogleUseCase(repository);
  });

  test('autentica com Google e faz upsert do perfil', () async {
    final user = TestFixtures.user(email: 'google@test.com');

    when(() => repository.signInWithGoogle()).thenAnswer((_) async => user);
    when(
      () => repository.upsertUserProfile(
        userEntity: any(named: 'userEntity'),
        extra: any(named: 'extra'),
      ),
    ).thenAnswer((_) async {});

    final result = await useCase();

    expect(result.email, user.email);
    verify(() => repository.signInWithGoogle()).called(1);
    verify(
      () => repository.upsertUserProfile(
        userEntity: user,
        extra: any(named: 'extra'),
      ),
    ).called(1);
  });
}
