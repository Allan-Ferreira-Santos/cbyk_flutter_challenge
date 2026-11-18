import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cbyk_flutter_challenge/core/data/services/session_service.dart';
import 'package:cbyk_flutter_challenge/features/home/data/data_source/home_data_source.dart';
import 'package:cbyk_flutter_challenge/features/home/data/repositories/home_repository.dart';
import 'package:cbyk_flutter_challenge/features/home/domain/use_cases/get_current_user_use_case.dart';
import 'package:cbyk_flutter_challenge/features/home/domain/use_cases/logout_use_case.dart';
import 'package:cbyk_flutter_challenge/features/home/presentation/cubit/home_cubit.dart';
import 'package:cbyk_flutter_challenge/features/home/presentation/modules/home_module.dart';

import '../../../../support/fixtures.dart';
import '../../../../support/mocks.dart';

void main() {
  setUp(() => Get.reset());
  tearDown(() => Get.reset());

  test('HomeModule registra e resolve dependências com data source mock', () {
    final session = MockSessionService();
    final dataSource = MockHomeDataSource();
    final user = TestFixtures.user();
    when(() => session.currentUser).thenReturn(user);

    Get.put<SessionService>(session);
    Get.put<HomeDataSource>(dataSource);
    HomeModule().dependencies();

    final cubit = Get.find<HomeCubit>();
    expect(cubit.state.user?.id, user.id);
    expect(Get.find<HomeRepository>(), isA<HomeRepository>());
    expect(Get.find<GetCurrentUserUseCase>(), isA<GetCurrentUserUseCase>());
    expect(Get.find<LogoutUseCase>(), isA<LogoutUseCase>());
  });

  test('HomeModule é idempotente quando já registrado', () {
    final session = MockSessionService();
    final dataSource = MockHomeDataSource();
    when(() => session.currentUser).thenReturn(TestFixtures.user());

    Get.put<SessionService>(session);
    Get.put<HomeDataSource>(dataSource);
    HomeModule().dependencies();
    HomeModule().dependencies();

    expect(Get.isRegistered<HomeCubit>(), isTrue);
  });

  test('HomeModule registra factory padrão do HomeDataSource', () {
    final session = MockSessionService();
    when(() => session.currentUser).thenReturn(TestFixtures.user());

    Get.put<SessionService>(session);
    HomeModule().dependencies();

    expect(Get.isRegistered<HomeDataSource>(), isTrue);
    expect(Get.isRegistered<HomeCubit>(), isTrue);
  });
}
