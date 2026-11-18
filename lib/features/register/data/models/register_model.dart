import 'package:cbyk_flutter_challenge/features/register/domain/entities/register_entity.dart';

class RegisterModel {
  const RegisterModel({
    required this.email,
    required this.password,
    required this.name,
    required this.cpf,
  });

  final String email;
  final String password;
  final String name;
  final String cpf;

  factory RegisterModel.fromEntity(RegisterEntity entity) {
    return RegisterModel(
      email: entity.email,
      password: entity.password,
      name: entity.name,
      cpf: entity.cpf,
    );
  }

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      email: json['email'],
      password: json['password'],
      name: json['name'],
      cpf: json['cpf'],
    );
  }

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'name': name,
    'cpf': cpf,
  };
}
