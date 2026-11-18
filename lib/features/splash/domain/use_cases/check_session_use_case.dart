import 'package:cbyk_flutter_challenge/core/domain/entities/user_entity.dart';
import 'package:cbyk_flutter_challenge/features/splash/data/repositories/splash_repository.dart';

class CheckSessionUseCase {
  CheckSessionUseCase(this.splashRepository);

  final SplashRepository splashRepository;

  Future<UserEntity?> call() async {
    try {
      return await splashRepository.getCurrentUser();
    } catch (_) {
      rethrow;
    }
  }
}
