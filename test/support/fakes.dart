import 'package:cbyk_flutter_challenge/core/data/services/session_service.dart';
import 'package:cbyk_flutter_challenge/core/domain/entities/user_entity.dart';
import 'package:cbyk_flutter_challenge/features/auth/data/repositories/auth_repository.dart';
import 'package:cbyk_flutter_challenge/features/auth/domain/entities/login_entity.dart';
import 'package:cbyk_flutter_challenge/features/home/data/repositories/home_repository.dart';
import 'package:cbyk_flutter_challenge/features/register/data/repositories/register_repository.dart';
import 'package:cbyk_flutter_challenge/features/register/domain/entities/register_entity.dart';
import 'package:cbyk_flutter_challenge/features/splash/data/repositories/splash_repository.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.user});

  UserEntity? user;
  var loginCalls = 0;
  var googleCalls = 0;
  var upsertCalls = 0;
  String? lastPassword;
  Object? loginError;
  Object? googleError;

  @override
  Future<UserEntity> signInWithEmail({
    required LoginEntity loginEntity,
  }) async {
    loginCalls++;
    lastPassword = loginEntity.password;
    if (loginError != null) throw loginError!;
    if (loginEntity.password == 'fail') {
      throw Exception('CPF ou senha inválidos.');
    }
    user = UserEntity(
      id: '1',
      name: 'Caio Maximo',
      cpf: loginEntity.cpf,
      email: loginEntity.email,
    );
    return user!;
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    googleCalls++;
    if (googleError != null) throw googleError!;
    user = const UserEntity(
      id: 'google_1',
      name: 'Google User',
      cpf: '',
      email: 'google.user@gmail.com',
    );
    return user!;
  }

  @override
  Future<void> upsertUserProfile({
    required UserEntity userEntity,
    Map<String, dynamic> extra = const {},
  }) async {
    upsertCalls++;
    user = userEntity;
  }
}

class FakeRegisterRepository implements RegisterRepository {
  FakeRegisterRepository({this.user});

  UserEntity? user;
  var registerCalls = 0;
  Object? registerError;

  @override
  Future<UserEntity> signUpWithEmail({
    required RegisterEntity registerEntity,
  }) async {
    registerCalls++;
    if (registerError != null) throw registerError!;
    user = UserEntity(
      id: '2',
      name: registerEntity.name,
      cpf: registerEntity.cpf,
      email: registerEntity.email,
    );
    return user!;
  }
}

class FakeSplashRepository implements SplashRepository {
  FakeSplashRepository({this.user});

  UserEntity? user;

  @override
  Future<UserEntity?> getCurrentUser() async => user;
}

class FakeHomeRepository implements HomeRepository {
  FakeHomeRepository({this.user, this.sessionService});

  UserEntity? user;
  SessionService? sessionService;
  var logoutCalls = 0;
  Object? logoutError;

  @override
  UserEntity? getCurrentUser() => user;

  @override
  Future<void> logout() async {
    logoutCalls++;
    if (logoutError != null) throw logoutError!;
    user = null;
    sessionService?.clear();
  }
}
