import 'package:cbyk_flutter_challenge/core/domain/entities/user_entity.dart';
import 'package:cbyk_flutter_challenge/features/auth/utils/mappers/auth_user_mapper.dart';
import 'package:cbyk_flutter_challenge/features/auth/data/repositories/auth_repository.dart';

class LoginWithGoogleUseCase {
  LoginWithGoogleUseCase(this.authRepository);

  final AuthRepository authRepository;

  Future<UserEntity> call() async {
    try {
      final user = await authRepository.signInWithGoogle();
      await authRepository.upsertUserProfile(
        userEntity: user,
        extra: const {'provider': AuthUserMapper.googleProvider},
      );
      return user;
    } catch (_) {
      rethrow;
    }
  }
}
