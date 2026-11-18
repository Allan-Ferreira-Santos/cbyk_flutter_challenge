import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cbyk_flutter_challenge/core/config/app_config.dart';
import 'package:cbyk_flutter_challenge/core/helper/result_helper.dart';
import 'package:cbyk_flutter_challenge/core/exceptions/app_exception.dart';
import 'package:cbyk_flutter_challenge/core/helper/mask_input_helper.dart';
import 'package:cbyk_flutter_challenge/core/utils/mappers/app_message_exception_mapper.dart';
import 'package:cbyk_flutter_challenge/features/register/domain/entities/register_entity.dart';
import 'package:cbyk_flutter_challenge/features/register/presentation/cubit/register_state.dart';
import 'package:cbyk_flutter_challenge/features/register/utils/mappers/register_page_mapper.dart';
import 'package:cbyk_flutter_challenge/features/register/domain/use_cases/register_use_case.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({
    required RegisterUseCase registerUseCase,
  }) : _registerUseCase = registerUseCase,
       super(const RegisterState());

  final RegisterUseCase _registerUseCase;

  void onNameChanged(String value) => emit(state.copyWith(name: value));

  void onCpfChanged(String value) => emit(state.copyWith(cpf: value));

  void onPasswordChanged(String value) => emit(state.copyWith(password: value));

  void toggleObscurePassword() =>
      emit(state.copyWith(obscurePassword: !state.obscurePassword));

  void enableAutovalidate() {
    if (state.autovalidate) return;
    emit(state.copyWith(autovalidate: true));
  }

  Future<void> register() async {
    if (state.submitResult.isLoading) return;
    emit(state.copyWith(submitResult: ResultHelper.loading()));
    try {
      final cpfDigits = MaskInputHelper.unmaskCpf(state.cpf);
      final registerEntity = RegisterEntity(
        email: AppConfig.emailFromCpf(cpfDigits),
        password: state.password,
        name: state.name.trim(),
        cpf: cpfDigits,
      );
      final user = await _registerUseCase(registerEntity: registerEntity);
      emit(
        state.copyWith(
          submitResult: ResultHelper.success(
            data: user,
            titleMessage: RegisterPageMapper.registerSuccess,
          ),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          submitResult: ResultHelper.error(
            titleMessage: RegisterPageMapper.registerErrorTitle,
            descriptionMessage: _messageFromError(error),
          ),
        ),
      );
    }
  }

  String _messageFromError(Object error) {
    if (error is AppException) return error.message;
    return AppMessageExceptionMapper.unknownError;
  }
}
