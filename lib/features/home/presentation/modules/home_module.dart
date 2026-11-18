import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cbyk_flutter_challenge/core/data/services/session_service.dart';
import 'package:cbyk_flutter_challenge/features/home/presentation/cubit/home_cubit.dart';
import 'package:cbyk_flutter_challenge/features/home/domain/use_cases/logout_use_case.dart';
import 'package:cbyk_flutter_challenge/features/home/data/data_source/home_data_source.dart';
import 'package:cbyk_flutter_challenge/features/home/data/repositories/home_repository.dart';
import 'package:cbyk_flutter_challenge/features/home/data/data_source/home_data_source_impl.dart';
import 'package:cbyk_flutter_challenge/features/home/data/repositories/home_repository_impl.dart';
import 'package:cbyk_flutter_challenge/features/home/domain/use_cases/get_current_user_use_case.dart';

class HomeModule extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<HomeDataSource>()) {
      Get.lazyPut<HomeDataSource>(() => HomeDataSourceImpl(auth: FirebaseAuth.instance), fenix: true);
    }
    if (!Get.isRegistered<HomeRepository>()) {
      Get.lazyPut<HomeRepository>(
        () => HomeRepositoryImpl(
          homeDataSource: Get.find<HomeDataSource>(),
          sessionService: Get.find<SessionService>(),
        ),
        fenix: true,
      );
    }
    if (!Get.isRegistered<GetCurrentUserUseCase>()) {
      Get.lazyPut<GetCurrentUserUseCase>(
        () => GetCurrentUserUseCase(Get.find<HomeRepository>()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<LogoutUseCase>()) {
      Get.lazyPut<LogoutUseCase>(
        () => LogoutUseCase(Get.find<HomeRepository>()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<HomeCubit>()) {
      Get.lazyPut<HomeCubit>(
        () => HomeCubit(
          getCurrentUserUseCase: Get.find<GetCurrentUserUseCase>(),
          logoutUseCase: Get.find<LogoutUseCase>(),
        ),
        fenix: true,
      );
    }
  }
}
