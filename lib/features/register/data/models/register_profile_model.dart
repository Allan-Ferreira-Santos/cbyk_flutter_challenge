import 'package:cbyk_flutter_challenge/features/register/domain/entities/register_profile_entity.dart';

class RegisterProfileModel {
  const RegisterProfileModel({
    required this.id,
    required this.name,
    required this.cpf,
    required this.email,
  });

  final String id;
  final String name;
  final String cpf;
  final String email;

  factory RegisterProfileModel.fromJson(Map<String, dynamic> json) {
    return RegisterProfileModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      cpf: json['cpf'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'cpf': cpf,
        'email': email,
      };

  RegisterProfileEntity toEntity() {
    return RegisterProfileEntity(
      id: id,
      name: name,
      cpf: cpf,
      email: email,
    );
  }
}
