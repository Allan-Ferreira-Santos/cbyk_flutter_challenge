import 'package:firebase_auth/firebase_auth.dart';
import 'package:cbyk_flutter_challenge/core/domain/entities/user_entity.dart';
import 'package:cbyk_flutter_challenge/core/data/services/session_service.dart';
import 'package:cbyk_flutter_challenge/features/auth/data/models/user_model.dart';
import 'package:cbyk_flutter_challenge/features/auth/data/models/login_model.dart';
import 'package:cbyk_flutter_challenge/core/helper/firebase_exception_helper.dart';
import 'package:cbyk_flutter_challenge/features/auth/domain/entities/login_entity.dart';
import 'package:cbyk_flutter_challenge/features/auth/data/data_source/auth_data_source.dart';
import 'package:cbyk_flutter_challenge/features/auth/data/repositories/auth_repository.dart';


class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthDataSource authDataSource,
    required SessionService sessionService,
  }) : _dataSource = authDataSource,
       _sessionService = sessionService;

  final AuthDataSource _dataSource;
  final SessionService _sessionService;

  @override
  Future<UserEntity> signInWithEmail({required LoginEntity loginEntity}) async {
    try {
      final model = LoginModel.fromEntity(loginEntity);
      final data = await _dataSource.signInWithEmail(data: model.toJson());
      final user = UserModel.fromJson(data).toEntity();
      _sessionService.setUser(user);
      return user;
    } on FirebaseAuthException catch (exception) {
      throw FirebaseExceptionHelper.fromAuth(exception);
    } on FirebaseException catch (exception) {
      throw FirebaseExceptionHelper.fromFirestore(exception);
    }
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    try {
      final data = await _dataSource.signInWithGoogle();
      final user = UserModel.fromJson(data).toEntity();
      _sessionService.setUser(user);
      return user;
    } on FirebaseAuthException catch (exception) {
      throw FirebaseExceptionHelper.fromAuth(exception);
    } on FirebaseException catch (exception) {
      throw FirebaseExceptionHelper.fromFirestore(exception);
    }
  }

  @override
  Future<void> upsertUserProfile({
    required UserEntity userEntity,
    Map<String, dynamic> extra = const {},
  }) async {
    try {
      await _dataSource.upsertProfile(
        uid: userEntity.id,
        profile: {...UserModel.fromEntity(userEntity).toJson(), ...extra},
      );
    } on FirebaseException catch (exception) {
      throw FirebaseExceptionHelper.fromFirestore(exception);
    }
  }
}
