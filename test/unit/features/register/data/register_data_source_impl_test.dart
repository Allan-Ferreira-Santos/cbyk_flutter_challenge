import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cbyk_flutter_challenge/features/register/data/data_source/register_data_source_impl.dart';

import '../../../../support/mocks.dart';

void main() {
  late MockFirebaseAuth auth;
  late FakeFirebaseFirestore firestore;
  late RegisterDataSourceImpl dataSource;

  setUp(() {
    auth = MockFirebaseAuth();
    firestore = FakeFirebaseFirestore();
    dataSource = RegisterDataSourceImpl(auth: auth, firestore: firestore);
  });

  test('signUpWithEmail cria usuário e perfil', () async {
    final credential = MockUserCredential();
    final user = MockFirebaseUser();
    when(() => user.uid).thenReturn('uid-new');
    when(() => user.updateDisplayName(any())).thenAnswer((_) async {});
    when(() => credential.user).thenReturn(user);
    when(
      () => auth.createUserWithEmailAndPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => credential);

    final result = await dataSource.signUpWithEmail(
      data: {
        'email': 'a@b.c',
        'password': '123456',
        'name': 'Allan',
        'cpf': '52998224725',
      },
    );

    expect(result['id'], 'uid-new');
    expect(result['name'], 'Allan');
    verify(() => user.updateDisplayName('Allan')).called(1);

    final doc = await firestore.collection('users').doc('uid-new').get();
    expect(doc.data()?['name'], 'Allan');
    expect(doc.data()?['cpf'], '52998224725');
  });

  test('signUpWithEmail lança quando uid vazio', () async {
    final credential = MockUserCredential();
    when(() => credential.user).thenReturn(null);
    when(
      () => auth.createUserWithEmailAndPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => credential);

    expect(
      () => dataSource.signUpWithEmail(
        data: {'email': 'a@b.c', 'password': '123456'},
      ),
      throwsA(isA<FirebaseAuthException>()),
    );
  });
}
