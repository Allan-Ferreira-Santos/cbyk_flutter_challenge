class LoginEntity {
  const LoginEntity({
    required this.email,
    required this.password,
    required this.cpf,
  });

  final String email;
  final String password;
  final String cpf;
}
