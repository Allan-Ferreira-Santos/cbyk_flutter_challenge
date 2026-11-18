import 'package:cbyk_flutter_challenge/core/domain/entities/user_entity.dart';
import 'package:cbyk_flutter_challenge/features/auth/domain/entities/login_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signInWithEmail({required LoginEntity loginEntity});

  Future<UserEntity> signInWithGoogle();

  Future<void> upsertUserProfile({
    required UserEntity userEntity,
    Map<String, dynamic> extra = const {},
  });
}
