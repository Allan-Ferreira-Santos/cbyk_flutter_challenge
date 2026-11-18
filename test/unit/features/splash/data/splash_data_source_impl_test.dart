import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cbyk_flutter_challenge/features/splash/data/data_source/splash_data_source_impl.dart';

import '../../../../support/mocks.dart';

void main() {
  late MockFirebaseAuth auth;
  late FakeFirebaseFirestore firestore;
  late SplashDataSourceImpl dataSource;

  setUp(() {
    auth = MockFirebaseAuth();
    firestore = FakeFirebaseFirestore();
    dataSource = SplashDataSourceImpl(auth: auth, firestore: firestore);
  });

  test('retorna null sem usuário autenticado', () async {
    when(() => auth.currentUser).thenReturn(null);

    expect(await dataSource.getCurrentUser(), isNull);
  });

  test('monta perfil a partir do Firestore', () async {
    final user = MockFirebaseUser();
    when(() => user.uid).thenReturn('uid-1');
    when(() => user.displayName).thenReturn('Display');
    when(() => user.email).thenReturn('a@b.c');
    when(() => auth.currentUser).thenReturn(user);

    await firestore.collection('users').doc('uid-1').set({
      'name': 'Allan',
      'cpf': '52998224725',
      'email': 'a@b.c',
    });

    final result = await dataSource.getCurrentUser();

    expect(result, {
      'id': 'uid-1',
      'name': 'Allan',
      'email': 'a@b.c',
      'cpf': '52998224725',
    });
  });

  test('usa fallbacks quando doc vazio', () async {
    final user = MockFirebaseUser();
    when(() => user.uid).thenReturn('uid-2');
    when(() => user.displayName).thenReturn('Fallback');
    when(() => user.email).thenReturn('x@y.z');
    when(() => auth.currentUser).thenReturn(user);

    final result = await dataSource.getCurrentUser();

    expect(result?['name'], 'Fallback');
    expect(result?['email'], 'x@y.z');
    expect(result?['cpf'], '');
  });
}
