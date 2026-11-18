import 'package:cbyk_flutter_challenge/core/domain/entities/user_entity.dart';

abstract class SplashRepository {
  Future<UserEntity?> getCurrentUser();
}
