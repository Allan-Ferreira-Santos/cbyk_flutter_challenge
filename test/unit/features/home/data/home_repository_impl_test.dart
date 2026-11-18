import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cbyk_flutter_challenge/core/data/services/session_service.dart';
import 'package:cbyk_flutter_challenge/core/exceptions/app_exception.dart';
import 'package:cbyk_flutter_challenge/features/home/data/data_source/home_data_source.dart';
import 'package:cbyk_flutter_challenge/features/home/data/repositories/home_repository_impl.dart';

import '../../../../support/fixtures.dart';

class MockHomeDataSource extends Mock implements HomeDataSource {}

void main() {
  late MockHomeDataSource dataSource;
  late SessionService session;
  late HomeRepositoryImpl repository;

  setUp(() {
    dataSource = MockHomeDataSource();
    session = SessionService()..setUser(TestFixtures.user());
    repository = HomeRepositoryImpl(
      homeDataSource: dataSource,
      sessionService: session,
    );
  });

  test('getCurrentUser lê da sessão', () {
    expect(repository.getCurrentUser()?.id, isNotEmpty);
  });

  test('logout limpa sessão', () async {
    when(() => dataSource.signOut()).thenAnswer((_) async {});
    await repository.logout();
    expect(session.currentUser, isNull);
  });

  test('logout propaga FirebaseAuthException', () async {
    when(() => dataSource.signOut()).thenThrow(
      FirebaseAuthException(code: 'network-request-failed'),
    );

    expect(
      () => repository.logout(),
      throwsA(isA<NetworkException>()),
    );
  });
}
