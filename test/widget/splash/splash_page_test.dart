import 'package:get/get.dart';
import '../../support/mocks.dart';
import '../../support/fixtures.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cbyk_flutter_challenge/core/config/theme/app_theme.dart';
import 'package:cbyk_flutter_challenge/core/config/routes/app_routes_mapper.dart';
import 'package:cbyk_flutter_challenge/features/splash/presentation/pages/splash_page.dart';
import 'package:cbyk_flutter_challenge/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:cbyk_flutter_challenge/features/splash/presentation/cubit/splash_state.dart';


class _UndecidedSplashCubit extends SplashCubit {
  _UndecidedSplashCubit(super.checkSession);

  @override
  Future<void> checkSession() async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    emit(const SplashState(isAuthenticated: null));
  }
}

void main() {
  late MockCheckSessionUseCase checkSession;
  late SplashCubit cubit;

  setUp(() {
    Get.reset();
    checkSession = MockCheckSessionUseCase();
    cubit = SplashCubit(checkSession);
    Get.put(cubit, permanent: true);
  });

  tearDown(() async {
    await cubit.close();
    Get.reset();
  });

  Future<void> pumpSplash(WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.dark,
        initialRoute: AppRoutesMapper.splash,
        getPages: [
          GetPage(name: AppRoutesMapper.splash, page: () => const SplashPage()),
          GetPage(
            name: AppRoutesMapper.home,
            page: () => const Scaffold(body: Text('home-screen')),
          ),
          GetPage(
            name: AppRoutesMapper.login,
            page: () => const Scaffold(body: Text('login-screen')),
          ),
        ],
      ),
    );
  }

  testWidgets('mostra marca e loading enquanto verifica a sessão', (
    tester,
  ) async {
    when(() => checkSession()).thenAnswer((_) async => null);
    await pumpSplash(tester);

    expect(find.text('Tokio Marine'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();
  });

  testWidgets('com sessão ativa navega para a home', (tester) async {
    when(() => checkSession()).thenAnswer((_) async => TestFixtures.user());
    await pumpSplash(tester);

    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();

    expect(find.text('home-screen'), findsOneWidget);
  });

  testWidgets('sem sessão navega para o login', (tester) async {
    when(() => checkSession()).thenAnswer((_) async => null);
    await pumpSplash(tester);

    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();

    expect(find.text('login-screen'), findsOneWidget);
  });

  testWidgets('estado indefinido permanece na splash', (tester) async {
    Get.reset();
    final undecided = _UndecidedSplashCubit(checkSession);
    Get.put<SplashCubit>(undecided, permanent: true);
    await pumpSplash(tester);
    await tester.pump(const Duration(milliseconds: 900));

    expect(find.text('Tokio Marine'), findsOneWidget);
    expect(find.text('home-screen'), findsNothing);
    expect(find.text('login-screen'), findsNothing);
    await undecided.close();
  });
}
