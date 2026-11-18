import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cbyk_flutter_challenge/features/splash/domain/use_cases/check_session_use_case.dart';
import 'package:cbyk_flutter_challenge/features/splash/presentation/cubit/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._checkSessionUseCase) : super(const SplashState());

  final CheckSessionUseCase _checkSessionUseCase;

  Future<void> checkSession() async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    final user = await _checkSessionUseCase();
    emit(SplashState(isAuthenticated: user != null));
  }
}
