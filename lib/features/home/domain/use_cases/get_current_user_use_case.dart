import 'package:cbyk_flutter_challenge/core/domain/entities/user_entity.dart';
import 'package:cbyk_flutter_challenge/features/home/data/repositories/home_repository.dart';

class GetCurrentUserUseCase {
  GetCurrentUserUseCase(this.homeRepository);

  final HomeRepository homeRepository;

  UserEntity? call() {
    try {
      return homeRepository.getCurrentUser();
    } catch (_) {
      rethrow;
    }
  }
}
