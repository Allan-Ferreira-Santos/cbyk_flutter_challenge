import 'package:get/get.dart';

import 'package:cbyk_flutter_challenge/core/data/services/session_service.dart';
import 'package:cbyk_flutter_challenge/features/splash/data/data_source/splash_data_source.dart';
import 'package:cbyk_flutter_challenge/features/splash/data/data_source/splash_data_source_impl.dart';
import 'package:cbyk_flutter_challenge/features/splash/data/repositories/splash_repository.dart';
import 'package:cbyk_flutter_challenge/features/splash/data/repositories/splash_repository_impl.dart';
import 'package:cbyk_flutter_challenge/features/splash/domain/use_cases/check_session_use_case.dart';
import 'package:cbyk_flutter_challenge/features/splash/presentation/cubit/splash_cubit.dart';

class SplashModule extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashDataSource>(
      () => SplashDataSourceImpl(),
      fenix: true,
    );
    Get.lazyPut<SplashRepository>(
      () => SplashRepositoryImpl(
        splashDataSource: Get.find<SplashDataSource>(),
        sessionService: Get.find<SessionService>(),
      ),
      fenix: true,
    );
    Get.lazyPut<CheckSessionUseCase>(
      () => CheckSessionUseCase(Get.find<SplashRepository>()),
      fenix: true,
    );
    Get.lazyPut<SplashCubit>(
      () => SplashCubit(Get.find<CheckSessionUseCase>()),
      fenix: true,
    );
  }
}
