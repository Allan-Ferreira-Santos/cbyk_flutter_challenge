import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cbyk_flutter_challenge/core/exceptions/app_exception.dart';
import 'package:cbyk_flutter_challenge/features/splash/data/repositories/splash_repository_impl.dart';

import '../../../../support/fixtures.dart';
import '../../../../support/mocks.dart';

void main() {
  late MockSplashDataSource dataSource;
  late MockSessionService session;
  late SplashRepositoryImpl repository;

  setUpAll(registerFallbackValues);

  setUp(() {
    dataSource = MockSplashDataSource();
    session = MockSessionService();
    repository = SplashRepositoryImpl(
      splashDataSource: dataSource,
      sessionService: session,
    );
  });

  test('retorna usuário em cache', () async {
    final user = TestFixtures.user();
    when(() => session.currentUser).thenReturn(user);

    final result = await repository.getCurrentUser();

    expect(result, user);
    verifyNever(() => dataSource.getCurrentUser());
  });

  test('busca no data source quando sem cache', () async {
    final user = TestFixtures.user();
    when(() => session.currentUser).thenReturn(null);
    when(() => dataSource.getCurrentUser()).thenAnswer(
      (_) async => {
        'id': user.id,
        'name': user.name,
        'cpf': user.cpf,
        'email': user.email,
      },
    );
    when(() => session.setUser(any())).thenReturn(null);

    final result = await repository.getCurrentUser();

    expect(result?.id, user.id);
    verify(() => session.setUser(any())).called(1);
  });

  test('retorna null quando data source vazio', () async {
    when(() => session.currentUser).thenReturn(null);
    when(() => dataSource.getCurrentUser()).thenAnswer((_) async => null);

    expect(await repository.getCurrentUser(), isNull);
  });

  test('propaga FirebaseAuthException', () async {
    when(() => session.currentUser).thenReturn(null);
    when(() => dataSource.getCurrentUser()).thenThrow(
      FirebaseAuthException(code: 'network-request-failed'),
    );

    expect(
      () => repository.getCurrentUser(),
      throwsA(isA<NetworkException>()),
    );
  });

  test('propaga FirebaseException', () async {
    when(() => session.currentUser).thenReturn(null);
    when(() => dataSource.getCurrentUser()).thenThrow(
      FirebaseException(plugin: 'firestore', code: 'unavailable'),
    );

    expect(
      () => repository.getCurrentUser(),
      throwsA(isA<UnavailableException>()),
    );
  });
}
