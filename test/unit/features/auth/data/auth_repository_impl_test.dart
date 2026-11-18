import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cbyk_flutter_challenge/core/exceptions/app_exception.dart';
import 'package:cbyk_flutter_challenge/features/auth/data/repositories/auth_repository_impl.dart';

import '../../../../support/fixtures.dart';
import '../../../../support/mocks.dart';

void main() {
  late MockAuthDataSource dataSource;
  late MockSessionService session;
  late AuthRepositoryImpl repository;

  setUpAll(registerFallbackValues);

  setUp(() {
    dataSource = MockAuthDataSource();
    session = MockSessionService();
    repository = AuthRepositoryImpl(
      authDataSource: dataSource,
      sessionService: session,
    );
    when(() => session.setUser(any())).thenReturn(null);
  });

  test('signInWithEmail salva sessão', () async {
    final login = TestFixtures.login();
    final user = TestFixtures.user(email: login.email, cpf: login.cpf);
    when(
      () => dataSource.signInWithEmail(data: any(named: 'data')),
    ).thenAnswer(
      (_) async => {
        'id': user.id,
        'name': user.name,
        'cpf': user.cpf,
        'email': user.email,
      },
    );

    final result = await repository.signInWithEmail(loginEntity: login);

    expect(result.email, user.email);
    verify(() => session.setUser(any())).called(1);
  });

  test('signInWithEmail propaga FirebaseAuthException', () async {
    when(
      () => dataSource.signInWithEmail(data: any(named: 'data')),
    ).thenThrow(FirebaseAuthException(code: 'wrong-password'));

    expect(
      () => repository.signInWithEmail(loginEntity: TestFixtures.login()),
      throwsA(isA<UnauthorizedException>()),
    );
  });

  test('signInWithEmail propaga FirebaseException', () async {
    when(
      () => dataSource.signInWithEmail(data: any(named: 'data')),
    ).thenThrow(
      FirebaseException(plugin: 'firestore', code: 'unavailable'),
    );

    expect(
      () => repository.signInWithEmail(loginEntity: TestFixtures.login()),
      throwsA(isA<UnavailableException>()),
    );
  });

  test('signInWithGoogle salva sessão', () async {
    final user = TestFixtures.user();
    when(() => dataSource.signInWithGoogle()).thenAnswer(
      (_) async => {
        'id': user.id,
        'name': user.name,
        'cpf': user.cpf,
        'email': user.email,
      },
    );

    final result = await repository.signInWithGoogle();
    expect(result.id, user.id);
    verify(() => session.setUser(any())).called(1);
  });

  test('signInWithGoogle propaga FirebaseAuthException', () async {
    when(() => dataSource.signInWithGoogle()).thenThrow(
      FirebaseAuthException(code: 'popup-closed-by-user'),
    );

    expect(
      () => repository.signInWithGoogle(),
      throwsA(isA<CancelledException>()),
    );
  });

  test('signInWithGoogle propaga FirebaseException', () async {
    when(() => dataSource.signInWithGoogle()).thenThrow(
      FirebaseException(plugin: 'firestore', code: 'permission-denied'),
    );

    expect(
      () => repository.signInWithGoogle(),
      throwsA(isA<PermissionDeniedException>()),
    );
  });

  test('upsertUserProfile chama data source', () async {
    final user = TestFixtures.user();
    when(
      () => dataSource.upsertProfile(
        uid: any(named: 'uid'),
        profile: any(named: 'profile'),
      ),
    ).thenAnswer((_) async {});

    await repository.upsertUserProfile(userEntity: user, extra: {'x': 1});

    verify(
      () => dataSource.upsertProfile(
        uid: user.id,
        profile: any(named: 'profile'),
      ),
    ).called(1);
  });

  test('upsertUserProfile propaga FirebaseException', () async {
    when(
      () => dataSource.upsertProfile(
        uid: any(named: 'uid'),
        profile: any(named: 'profile'),
      ),
    ).thenThrow(
      FirebaseException(plugin: 'firestore', code: 'already-exists'),
    );

    expect(
      () => repository.upsertUserProfile(userEntity: TestFixtures.user()),
      throwsA(isA<AlreadyExistsException>()),
    );
  });
}
