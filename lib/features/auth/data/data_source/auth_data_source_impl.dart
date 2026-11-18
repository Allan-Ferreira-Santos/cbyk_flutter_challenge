import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cbyk_flutter_challenge/features/auth/data/data_source/auth_data_source.dart';

class AuthDataSourceImpl implements AuthDataSource {
  AuthDataSourceImpl({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    bool? isWeb,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _isWeb = isWeb ?? kIsWeb;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final bool _isWeb;

  @override
  Future<Map<String, dynamic>> signInWithEmail({
    required Map<String, dynamic> data,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: data['email'],
      password: data['password'],
    );
    return _userDataFromCredential(credential: credential);
  }

  @override
  Future<Map<String, dynamic>> signInWithGoogle() async {
    final provider = GoogleAuthProvider()
      ..addScope('email')
      ..setCustomParameters({'prompt': 'select_account'});

    final UserCredential credential;
    if (_isWeb) {
      credential = await _auth.signInWithPopup(provider);
    } else {
      credential = await _auth.signInWithProvider(provider);
    }

    return _userDataFromCredential(credential: credential);
  }

  @override
  Future<void> upsertProfile({
    required String uid,
    required Map<String, dynamic> profile,
  }) {
    return _firestore.collection('users').doc(uid).set({
      ...profile,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>> _userDataFromCredential({
    required UserCredential credential,
  }) async {
    final firebaseUser = credential.user;
    if (firebaseUser == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'Usuário não retornado pelo Firebase Auth.',
      );
    }

    final doc = await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .get();
    final data = doc.data();

    return {
      'id': firebaseUser.uid,
      'name': data?['name'] ?? firebaseUser.displayName ?? '',
      'cpf': data?['cpf'] ?? '',
      'email': firebaseUser.email ?? data?['email'] ?? '',
    };
  }
}
