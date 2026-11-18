import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cbyk_flutter_challenge/core/config/app_config.dart';
import 'package:cbyk_flutter_challenge/core/helper/result_helper.dart';
import 'package:cbyk_flutter_challenge/core/exceptions/app_exception.dart';
import 'package:cbyk_flutter_challenge/core/helper/mask_input_helper.dart';
import 'package:cbyk_flutter_challenge/core/data/services/preferences_service.dart';
import 'package:cbyk_flutter_challenge/features/auth/domain/entities/login_entity.dart';
import 'package:cbyk_flutter_challenge/features/auth/presentation/cubit/login_state.dart';
import 'package:cbyk_flutter_challenge/features/auth/utils/mappers/login_page_mapper.dart';
import 'package:cbyk_flutter_challenge/features/auth/domain/use_cases/login_use_case.dart';
import 'package:cbyk_flutter_challenge/core/utils/mappers/app_message_exception_mapper.dart';
import 'package:cbyk_flutter_challenge/features/auth/domain/use_cases/login_with_google_use_case.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required LoginUseCase loginUseCase,
    required LoginWithGoogleUseCase loginWithGoogleUseCase,
    required PreferencesService preferencesService,
  }) : _loginUseCase = loginUseCase,
       _loginWithGoogleUseCase = loginWithGoogleUseCase,
       _preferencesService = preferencesService,
       super(const LoginState());

  final LoginUseCase _loginUseCase;
  final LoginWithGoogleUseCase _loginWithGoogleUseCase;
  final PreferencesService _preferencesService;

  void loadSavedPreferences() {
    final remember = _preferencesService.rememberAlways;
    final savedCpf = _preferencesService.savedCpf;
    emit(
      state.copyWith(
        rememberAlways: remember,
        cpf: remember ? MaskInputHelper.formatCpf(savedCpf) : '',
      ),
    );
  }

  void onCpfChanged(String value) => emit(state.copyWith(cpf: value));

  void onPasswordChanged(String value) => emit(state.copyWith(password: value));

  void toggleRememberAlways(bool? value) =>
      emit(state.copyWith(rememberAlways: value ?? false));

  void toggleObscurePassword() =>
      emit(state.copyWith(obscurePassword: !state.obscurePassword));

  void enableAutovalidate() {
    if (state.autovalidate) return;
    emit(state.copyWith(autovalidate: true));
  }

  Future<void> login() async {
    if (state.submitResult.isLoading) return;
    emit(state.copyWith(submitResult: ResultHelper.loading()));
    try {
      final cpfDigits = MaskInputHelper.unmaskCpf(state.cpf);
      final loginEntity = LoginEntity(
        email: AppConfig.emailFromCpf(cpfDigits),
        password: state.password,
        cpf: cpfDigits,
      );
      final user = await _loginUseCase(loginEntity: loginEntity);
      await _persistRemember();
      emit(state.copyWith(submitResult: ResultHelper.success(data: user)));
    } catch (error) {
      emit(
        state.copyWith(
          submitResult: ResultHelper.error(
            titleMessage: LoginPageMapper.loginErrorTitle,
            descriptionMessage: _messageFromError(error),
          ),
        ),
      );
    }
  }

  Future<void> loginWithGoogle() async {
    if (state.submitResult.isLoading) return;
    emit(state.copyWith(submitResult: ResultHelper.loading()));
    try {
      final user = await _loginWithGoogleUseCase();
      emit(state.copyWith(submitResult: ResultHelper.success(data: user)));
    } catch (error) {
      emit(
        state.copyWith(
          submitResult: ResultHelper.error(
            titleMessage: LoginPageMapper.googleErrorTitle,
            descriptionMessage: _messageFromError(error),
          ),
        ),
      );
    }
  }

  Future<void> _persistRemember() async {
    await _preferencesService.setRememberAlways(state.rememberAlways);
    if (state.rememberAlways) {
      await _preferencesService.setSavedCpf(
        MaskInputHelper.unmaskCpf(state.cpf),
      );
      return;
    }
    await _preferencesService.setSavedCpf(null);
  }

  String _messageFromError(Object error) {
    if (error is AppException) return error.message;
    return AppMessageExceptionMapper.unknownError;
  }
}
