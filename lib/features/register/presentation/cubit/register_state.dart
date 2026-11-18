import 'package:cbyk_flutter_challenge/core/helper/result_helper.dart';
import 'package:cbyk_flutter_challenge/core/domain/entities/user_entity.dart';

class RegisterState {
  const RegisterState({
    this.name = '',
    this.cpf = '',
    this.password = '',
    this.obscurePassword = true,
    this.autovalidate = false,
    this.submitResult = const ResultHelper.initial(),
  });

  final String name;
  final String cpf;
  final String password;
  final bool obscurePassword;
  final bool autovalidate;
  final ResultHelper<UserEntity> submitResult;

  RegisterState copyWith({
    String? name,
    String? cpf,
    String? password,
    bool? obscurePassword,
    bool? autovalidate,
    ResultHelper<UserEntity>? submitResult,
  }) {
    return RegisterState(
      name: name ?? this.name,
      cpf: cpf ?? this.cpf,
      password: password ?? this.password,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      autovalidate: autovalidate ?? this.autovalidate,
      submitResult: submitResult ?? this.submitResult,
    );
  }
}
