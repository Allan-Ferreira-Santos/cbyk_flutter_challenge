import 'package:cbyk_flutter_challenge/core/domain/entities/user_entity.dart';

class SplashUserModel {
  const SplashUserModel({
    required this.id,
    required this.name,
    required this.cpf,
    required this.email,
  });

  final String id;
  final String name;
  final String cpf;
  final String email;

  factory SplashUserModel.fromJson(Map<String, dynamic> json) {
    return SplashUserModel(
      id: json['id'],
      name: json['name'],
      cpf: json['cpf'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'cpf': cpf,
    'email': email,
  };

  UserEntity toEntity() {
    return UserEntity(id: id, name: name, cpf: cpf, email: email);
  }
}
