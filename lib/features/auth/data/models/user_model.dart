import 'package:cbyk_flutter_challenge/core/domain/entities/user_entity.dart';

class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.cpf,
    required this.email,
  });

  final String id;
  final String name;
  final String cpf;
  final String email;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      cpf: json['cpf'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      cpf: entity.cpf,
      email: entity.email,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'cpf': cpf,
        'email': email,
      };

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      cpf: cpf,
      email: email,
    );
  }
}
