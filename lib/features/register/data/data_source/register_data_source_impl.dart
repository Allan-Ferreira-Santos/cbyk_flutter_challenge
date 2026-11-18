import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cbyk_flutter_challenge/features/register/data/data_source/register_data_source.dart';


class RegisterDataSourceImpl implements RegisterDataSource {
  RegisterDataSourceImpl({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  @override
  Future<Map<String, dynamic>> signUpWithEmail({
    required Map<String, dynamic> data,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: data['email'],
      password: data['password'],
    );
    final userId = credential.user?.uid;
    if (userId == null || userId.isEmpty) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'Usuário não criado no Firebase Auth.',
      );
    }

    final profile = {
      'id': userId,
      'name': data['name'] ?? '',
      'cpf': data['cpf'] ?? '',
      'email': data['email'] ?? '',
    };

    await credential.user?.updateDisplayName(profile['name'] as String);
    await _firestore.collection('users').doc(userId).set({
      ...profile,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return profile;
  }
}
