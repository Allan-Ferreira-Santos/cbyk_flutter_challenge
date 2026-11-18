import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cbyk_flutter_challenge/features/auth/data/data_source/auth_data_source_impl.dart';

import '../../../../support/mocks.dart';

class FakeAuthProvider extends Fake implements AuthProvider {}

void main() {
  late MockFirebaseAuth auth;
  late FakeFirebaseFirestore firestore;
  late AuthDataSourceImpl dataSource;

  setUpAll(() {
    registerFallbackValue(FakeAuthProvider());
  });

  setUp(() {
    auth = MockFirebaseAuth();
    firestore = FakeFirebaseFirestore();
    dataSource = AuthDataSourceImpl(auth: auth, firestore: firestore);
  });

  test('signInWithEmail retorna perfil', () async {
    final credential = MockUserCredential();
    final user = MockFirebaseUser();
    when(() => user.uid).thenReturn('uid-1');
    when(() => user.displayName).thenReturn('Name');
    when(() => user.email).thenReturn('a@b.c');
    when(() => credential.user).thenReturn(user);
    when(
      () => auth.signInWithEmailAndPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => credential);

    await firestore.collection('users').doc('uid-1').set({
      'name': 'Allan',
      'cpf': '52998224725',
    });

    final result = await dataSource.signInWithEmail(
      data: {'email': 'a@b.c', 'password': '123456'},
    );

    expect(result['id'], 'uid-1');
    expect(result['name'], 'Allan');
    expect(result['cpf'], '52998224725');
  });

  test('signInWithEmail lança quando user é null', () async {
    final credential = MockUserCredential();
    when(() => credential.user).thenReturn(null);
    when(
      () => auth.signInWithEmailAndPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => credential);

    expect(
      () => dataSource.signInWithEmail(
        data: {'email': 'a@b.c', 'password': '123456'},
      ),
      throwsA(isA<FirebaseAuthException>()),
    );
  });

  test('signInWithGoogle usa provider nativo', () async {
    final credential = MockUserCredential();
    final user = MockFirebaseUser();
    when(() => user.uid).thenReturn('uid-g');
    when(() => user.displayName).thenReturn(null);
    when(() => user.email).thenReturn('g@mail.com');
    when(() => credential.user).thenReturn(user);
    when(() => auth.signInWithProvider(any())).thenAnswer(
      (_) async => credential,
    );

    final result = await dataSource.signInWithGoogle();

    expect(result['id'], 'uid-g');
    expect(result['name'], '');
    expect(result['email'], 'g@mail.com');
  });

  test('signInWithGoogle usa popup na web', () async {
    final webDataSource = AuthDataSourceImpl(
      auth: auth,
      firestore: firestore,
      isWeb: true,
    );
    final credential = MockUserCredential();
    final user = MockFirebaseUser();
    when(() => user.uid).thenReturn('uid-web');
    when(() => user.displayName).thenReturn('Web');
    when(() => user.email).thenReturn('w@mail.com');
    when(() => credential.user).thenReturn(user);
    when(() => auth.signInWithPopup(any())).thenAnswer((_) async => credential);

    final result = await webDataSource.signInWithGoogle();
    expect(result['id'], 'uid-web');
    verify(() => auth.signInWithPopup(any())).called(1);
  });

  test('upsertProfile grava no Firestore', () async {
    await dataSource.upsertProfile(
      uid: 'uid-1',
      profile: {'name': 'Allan'},
    );

    final doc = await firestore.collection('users').doc('uid-1').get();
    expect(doc.data()?['name'], 'Allan');
  });
}
