import 'package:cbyk_flutter_challenge/core/domain/entities/user_entity.dart';
import 'package:cbyk_flutter_challenge/features/register/domain/entities/register_entity.dart';

abstract class RegisterRepository {
  Future<UserEntity> signUpWithEmail({required RegisterEntity registerEntity});
}
