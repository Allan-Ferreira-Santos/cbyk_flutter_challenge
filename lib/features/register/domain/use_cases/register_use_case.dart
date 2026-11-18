import 'package:cbyk_flutter_challenge/core/domain/entities/user_entity.dart';
import 'package:cbyk_flutter_challenge/features/register/domain/entities/register_entity.dart';
import 'package:cbyk_flutter_challenge/features/register/data/repositories/register_repository.dart';

class RegisterUseCase {
  RegisterUseCase(this.registerRepository);

  final RegisterRepository registerRepository;

  Future<UserEntity> call({required RegisterEntity registerEntity}) async {
    try {
      return await registerRepository.signUpWithEmail(registerEntity: registerEntity);
    } catch (_) {
      rethrow;
    }
  }
}
