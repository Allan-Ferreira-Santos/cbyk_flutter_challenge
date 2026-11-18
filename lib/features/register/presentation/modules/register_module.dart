import 'package:get/get.dart';

import 'package:cbyk_flutter_challenge/core/data/services/session_service.dart';
import 'package:cbyk_flutter_challenge/features/register/data/data_source/register_data_source.dart';
import 'package:cbyk_flutter_challenge/features/register/data/data_source/register_data_source_impl.dart';
import 'package:cbyk_flutter_challenge/features/register/data/repositories/register_repository.dart';
import 'package:cbyk_flutter_challenge/features/register/data/repositories/register_repository_impl.dart';
import 'package:cbyk_flutter_challenge/features/register/domain/use_cases/register_use_case.dart';
import 'package:cbyk_flutter_challenge/features/register/presentation/cubit/register_cubit.dart';

class RegisterModule extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterDataSource>(
      () => RegisterDataSourceImpl(),
      fenix: true,
    );
    Get.lazyPut<RegisterRepository>(
      () => RegisterRepositoryImpl(
        registerDataSource: Get.find<RegisterDataSource>(),
        sessionService: Get.find<SessionService>(),
      ),
      fenix: true,
    );
    Get.lazyPut<RegisterUseCase>(
      () => RegisterUseCase(Get.find<RegisterRepository>()),
      fenix: true,
    );
    Get.lazyPut<RegisterCubit>(
      () => RegisterCubit(
        registerUseCase: Get.find<RegisterUseCase>(),
      ),
      fenix: true,
    );
  }
}
