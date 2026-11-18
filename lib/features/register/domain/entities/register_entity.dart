class RegisterEntity {
  const RegisterEntity({
    required this.email,
    required this.password,
    required this.name,
    required this.cpf,
  });

  final String email;
  final String password;
  final String name;
  final String cpf;
}
