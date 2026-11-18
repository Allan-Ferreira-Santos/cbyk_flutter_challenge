import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cbyk_flutter_challenge/core/exceptions/app_exception.dart';
import 'package:cbyk_flutter_challenge/features/register/data/repositories/register_repository_impl.dart';

import '../../../../support/fixtures.dart';
import '../../../../support/mocks.dart';

void main() {
  late MockRegisterDataSource dataSource;
  late MockSessionService session;
  late RegisterRepositoryImpl repository;

  setUpAll(registerFallbackValues);

  setUp(() {
    dataSource = MockRegisterDataSource();
    session = MockSessionService();
    repository = RegisterRepositoryImpl(
      registerDataSource: dataSource,
      sessionService: session,
    );
    when(() => session.setUser(any())).thenReturn(null);
  });

  test('signUpWithEmail salva sessão', () async {
    final register = TestFixtures.register();
    when(
      () => dataSource.signUpWithEmail(data: any(named: 'data')),
    ).thenAnswer(
      (_) async => {
        'id': 'uid-1',
        'name': register.name,
        'cpf': register.cpf,
        'email': register.email,
      },
    );

    final user = await repository.signUpWithEmail(registerEntity: register);

    expect(user.id, 'uid-1');
    expect(user.email, register.email);
    verify(() => session.setUser(any())).called(1);
  });

  test('signUpWithEmail propaga FirebaseAuthException', () async {
    when(
      () => dataSource.signUpWithEmail(data: any(named: 'data')),
    ).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

    expect(
      () => repository.signUpWithEmail(
        registerEntity: TestFixtures.register(),
      ),
      throwsA(isA<AlreadyExistsException>()),
    );
  });

  test('signUpWithEmail propaga FirebaseException', () async {
    when(
      () => dataSource.signUpWithEmail(data: any(named: 'data')),
    ).thenThrow(
      FirebaseException(plugin: 'firestore', code: 'unavailable'),
    );

    expect(
      () => repository.signUpWithEmail(
        registerEntity: TestFixtures.register(),
      ),
      throwsA(isA<UnavailableException>()),
    );
  });
}
