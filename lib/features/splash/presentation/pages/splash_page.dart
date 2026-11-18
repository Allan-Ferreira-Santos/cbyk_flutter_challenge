import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cbyk_flutter_challenge/core/config/theme/app_colors.dart';
import 'package:cbyk_flutter_challenge/core/config/theme/app_gradients.dart';
import 'package:cbyk_flutter_challenge/core/config/routes/app_routes_mapper.dart';
import 'package:cbyk_flutter_challenge/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:cbyk_flutter_challenge/features/splash/presentation/cubit/splash_state.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final SplashCubit _cubit = Get.find<SplashCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.checkSession();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          switch (state.isAuthenticated) {
            case true:
              Get.offAllNamed(AppRoutesMapper.home);
            case false:
              Get.offAllNamed(AppRoutesMapper.login);
            case null:
              break;
          }
        },
        child: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(gradient: AppGradients.hero),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Tokio Marine',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
                ),
                SizedBox(height: 32),
                CircularProgressIndicator(color: AppColors.textPrimary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
