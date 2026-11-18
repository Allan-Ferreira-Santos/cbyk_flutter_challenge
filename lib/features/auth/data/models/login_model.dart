import 'package:cbyk_flutter_challenge/features/auth/domain/entities/login_entity.dart';

class LoginModel {
  const LoginModel({
    required this.email,
    required this.password,
    required this.cpf,
  });

  final String email;
  final String password;
  final String cpf;

  factory LoginModel.fromEntity(LoginEntity entity) {
    return LoginModel(
      email: entity.email,
      password: entity.password,
      cpf: entity.cpf,
    );
  }

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      cpf: json['cpf'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'cpf': cpf,
      };
}
