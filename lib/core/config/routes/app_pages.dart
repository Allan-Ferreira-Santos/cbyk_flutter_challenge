import 'package:get/get.dart';

import 'package:cbyk_flutter_challenge/core/config/routes/app_routes_mapper.dart';
import 'package:cbyk_flutter_challenge/core/presentation/widgets/placeholder_page.dart';
import 'package:cbyk_flutter_challenge/features/auth/presentation/modules/auth_module.dart';
import 'package:cbyk_flutter_challenge/features/auth/presentation/pages/login_page.dart';
import 'package:cbyk_flutter_challenge/features/home/presentation/modules/home_module.dart';
import 'package:cbyk_flutter_challenge/features/home/presentation/pages/home_page.dart';
import 'package:cbyk_flutter_challenge/features/register/presentation/modules/register_module.dart';
import 'package:cbyk_flutter_challenge/features/register/presentation/pages/register_page.dart';
import 'package:cbyk_flutter_challenge/features/splash/presentation/modules/splash_module.dart';
import 'package:cbyk_flutter_challenge/features/splash/presentation/pages/splash_page.dart';
import 'package:cbyk_flutter_challenge/features/webview/presentation/modules/webview_module.dart';
import 'package:cbyk_flutter_challenge/features/webview/presentation/pages/webview_page.dart';

class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutesMapper.splash,
      page: () => const SplashPage(),
      binding: SplashModule(),
    ),
    GetPage(
      name: AppRoutesMapper.login,
      page: () => const LoginPage(),
      binding: AuthModule(),
    ),
    GetPage(
      name: AppRoutesMapper.register,
      page: () => const RegisterPage(),
      binding: RegisterModule(),
    ),
    GetPage(
      name: AppRoutesMapper.home,
      page: () => const HomePage(),
      binding: HomeModule(),
    ),
    GetPage(
      name: AppRoutesMapper.webview,
      page: () => const WebViewPage(),
      binding: WebViewModule(),
    ),
    GetPage(
      name: AppRoutesMapper.placeholder,
      page: () => const PlaceholderPage(),
    ),
  ];
}
