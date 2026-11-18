import 'package:cbyk_flutter_challenge/features/home/data/repositories/home_repository.dart';

class LogoutUseCase {
  LogoutUseCase(this.homeRepository);

  final HomeRepository homeRepository;

  Future<void> call() async {
    try {
      await homeRepository.logout();
    } catch (_) {
      rethrow;
    }
  }
}
