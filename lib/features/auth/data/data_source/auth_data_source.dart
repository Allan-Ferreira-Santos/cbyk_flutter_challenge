abstract class AuthDataSource {
  Future<Map<String, dynamic>> signInWithEmail({
    required Map<String, dynamic> data,
  });

  Future<Map<String, dynamic>> signInWithGoogle();

  Future<void> upsertProfile({
    required String uid,
    required Map<String, dynamic> profile,
  });
}
