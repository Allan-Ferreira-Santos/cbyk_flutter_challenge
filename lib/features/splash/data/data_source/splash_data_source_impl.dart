import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cbyk_flutter_challenge/features/splash/data/data_source/splash_data_source.dart';

class SplashDataSourceImpl implements SplashDataSource {
  SplashDataSourceImpl({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  @override
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;

    final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
    final data = doc.data();

    return {
      'id': firebaseUser.uid,
      'name': data?['name'] ?? firebaseUser.displayName ?? '',
      'email': firebaseUser.email ?? data?['email'] ?? '',
      'cpf': data?['cpf'] ?? '',
    };
  }
}
