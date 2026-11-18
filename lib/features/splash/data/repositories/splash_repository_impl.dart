import 'package:firebase_auth/firebase_auth.dart';
import 'package:cbyk_flutter_challenge/core/domain/entities/user_entity.dart';
import 'package:cbyk_flutter_challenge/core/data/services/session_service.dart';
import 'package:cbyk_flutter_challenge/core/helper/firebase_exception_helper.dart';
import 'package:cbyk_flutter_challenge/features/splash/data/models/splash_user_model.dart';
import 'package:cbyk_flutter_challenge/features/splash/data/data_source/splash_data_source.dart';
import 'package:cbyk_flutter_challenge/features/splash/data/repositories/splash_repository.dart';


class SplashRepositoryImpl implements SplashRepository {
  SplashRepositoryImpl({
    required SplashDataSource splashDataSource,
    required SessionService sessionService,
  }) : splashDataSource = splashDataSource,
       sessionService = sessionService;

  final SplashDataSource splashDataSource;
  final SessionService sessionService;

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final cached = sessionService.currentUser;
      if (cached != null) return cached;

      final data = await splashDataSource.getCurrentUser();
      if (data == null) return null;

      final user = SplashUserModel.fromJson(data).toEntity();
      sessionService.setUser(user);
      return user;
    } on FirebaseAuthException catch (exception) {
      throw FirebaseExceptionHelper.fromAuth(exception);
    } on FirebaseException catch (exception) {
      throw FirebaseExceptionHelper.fromFirestore(exception);
    }
  }
}
