import 'package:firebase_auth/firebase_auth.dart';
import 'package:cbyk_flutter_challenge/core/domain/entities/user_entity.dart';
import 'package:cbyk_flutter_challenge/core/data/services/session_service.dart';
import 'package:cbyk_flutter_challenge/core/helper/firebase_exception_helper.dart';
import 'package:cbyk_flutter_challenge/features/register/data/models/register_model.dart';
import 'package:cbyk_flutter_challenge/features/register/domain/entities/register_entity.dart';
import 'package:cbyk_flutter_challenge/features/register/data/models/register_profile_model.dart';
import 'package:cbyk_flutter_challenge/features/register/data/data_source/register_data_source.dart';
import 'package:cbyk_flutter_challenge/features/register/data/repositories/register_repository.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  RegisterRepositoryImpl({
    required RegisterDataSource registerDataSource,
    required SessionService sessionService,
  }) : registerDataSource = registerDataSource,
       sessionService = sessionService;

  final RegisterDataSource registerDataSource;
  final SessionService sessionService;

  @override
  Future<UserEntity> signUpWithEmail({
    required RegisterEntity registerEntity,
  }) async {
    try {
      final model = RegisterModel.fromEntity(registerEntity);
      final data = await registerDataSource.signUpWithEmail(
        data: model.toJson(),
      );
      final profile = RegisterProfileModel.fromJson(data).toEntity();
      final user = UserEntity(
        id: profile.id,
        name: profile.name,
        email: profile.email,
        cpf: profile.cpf,
      );
      sessionService.setUser(user);
      return user;
    } on FirebaseAuthException catch (exception) {
      throw FirebaseExceptionHelper.fromAuth(exception);
    } on FirebaseException catch (exception) {
      throw FirebaseExceptionHelper.fromFirestore(exception);
    }
  }
}
