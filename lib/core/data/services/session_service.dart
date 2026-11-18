import 'package:cbyk_flutter_challenge/core/domain/entities/user_entity.dart';

class SessionService {
  UserEntity? _currentUser;

  UserEntity? get currentUser => _currentUser;

  bool get isAuthenticated => _currentUser != null;

  void setUser(UserEntity? user) => _currentUser = user;

  void clear() => _currentUser = null;
}
