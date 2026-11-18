import 'package:cbyk_flutter_challenge/core/domain/entities/user_entity.dart';
import 'package:cbyk_flutter_challenge/core/helper/result_helper.dart';

class LoginState {
  const LoginState({
    this.cpf = '',
    this.password = '',
    this.rememberAlways = false,
    this.obscurePassword = true,
    this.autovalidate = false,
    this.submitResult = const ResultHelper.initial(),
  });

  final String cpf;
  final String password;
  final bool rememberAlways;
  final bool obscurePassword;
  final bool autovalidate;
  final ResultHelper<UserEntity> submitResult;

  LoginState copyWith({
    String? cpf,
    String? password,
    bool? rememberAlways,
    bool? obscurePassword,
    bool? autovalidate,
    ResultHelper<UserEntity>? submitResult,
  }) {
    return LoginState(
      cpf: cpf ?? this.cpf,
      password: password ?? this.password,
      rememberAlways: rememberAlways ?? this.rememberAlways,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      autovalidate: autovalidate ?? this.autovalidate,
      submitResult: submitResult ?? this.submitResult,
    );
  }
}
