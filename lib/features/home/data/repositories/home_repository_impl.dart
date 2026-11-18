import 'package:firebase_auth/firebase_auth.dart';

import 'package:cbyk_flutter_challenge/core/domain/entities/user_entity.dart';
import 'package:cbyk_flutter_challenge/core/data/services/session_service.dart';
import 'package:cbyk_flutter_challenge/core/helper/firebase_exception_helper.dart';
import 'package:cbyk_flutter_challenge/features/home/data/data_source/home_data_source.dart';
import 'package:cbyk_flutter_challenge/features/home/data/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({
    required HomeDataSource homeDataSource,
    required SessionService sessionService,
  }) : _dataSource = homeDataSource,
       _sessionService = sessionService;

  final HomeDataSource _dataSource;
  final SessionService _sessionService;

  @override
  UserEntity? getCurrentUser() => _sessionService.currentUser;

  @override
  Future<void> logout() async {
    try {
      await _dataSource.signOut();
      _sessionService.clear();
    } on FirebaseAuthException catch (exception) {
      throw FirebaseExceptionHelper.fromAuth(exception);
    }
  }
}
