import 'package:cbyk_flutter_challenge/core/domain/entities/user_entity.dart';
import 'package:cbyk_flutter_challenge/features/auth/domain/entities/login_entity.dart';
import 'package:cbyk_flutter_challenge/features/auth/data/repositories/auth_repository.dart';

class LoginUseCase {
  LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<UserEntity> call({required LoginEntity loginEntity}) async {
    try {
      return await _repository.signInWithEmail(loginEntity: loginEntity);
    } catch (_) {
      rethrow;
    }
  }
}
