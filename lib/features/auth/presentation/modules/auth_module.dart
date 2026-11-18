import 'package:get/get.dart';
import 'package:cbyk_flutter_challenge/core/data/services/session_service.dart';
import 'package:cbyk_flutter_challenge/core/data/services/preferences_service.dart';
import 'package:cbyk_flutter_challenge/features/auth/presentation/cubit/login_cubit.dart';
import 'package:cbyk_flutter_challenge/features/auth/domain/use_cases/login_use_case.dart';
import 'package:cbyk_flutter_challenge/features/auth/data/data_source/auth_data_source.dart';
import 'package:cbyk_flutter_challenge/features/auth/data/repositories/auth_repository.dart';
import 'package:cbyk_flutter_challenge/features/auth/data/data_source/auth_data_source_impl.dart';
import 'package:cbyk_flutter_challenge/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:cbyk_flutter_challenge/features/auth/domain/use_cases/login_with_google_use_case.dart';


class AuthModule extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthDataSource>(() => AuthDataSourceImpl(), fenix: true);
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        authDataSource: Get.find<AuthDataSource>(),
        sessionService: Get.find<SessionService>(),
      ),
      fenix: true,
    );
    Get.lazyPut<LoginUseCase>(
      () => LoginUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut<LoginWithGoogleUseCase>(
      () => LoginWithGoogleUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut<LoginCubit>(
      () => LoginCubit(
        loginUseCase: Get.find<LoginUseCase>(),
        loginWithGoogleUseCase: Get.find<LoginWithGoogleUseCase>(),
        preferencesService: Get.find<PreferencesService>(),
      ),
      fenix: true,
    );
  }
}
