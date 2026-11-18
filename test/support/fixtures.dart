import 'package:faker/faker.dart';
import 'package:cbyk_flutter_challenge/core/domain/entities/user_entity.dart';
import 'package:cbyk_flutter_challenge/features/auth/domain/entities/login_entity.dart';
import 'package:cbyk_flutter_challenge/features/register/domain/entities/register_entity.dart';

class TestFixtures {

  static final faker = Faker();

  static const validCpfMasked = '529.982.247-25';
  static const validCpfDigits = '52998224725';

  static UserEntity user({
    String? id,
    String? name,
    String? cpf,
    String? email,
  }) {
    return UserEntity(
      id: id ?? faker.guid.guid(),
      name: name ?? faker.person.name(),
      cpf: cpf ?? validCpfDigits,
      email: email ?? faker.internet.email(),
    );
  }

  static LoginEntity login({
    String? email,
    String? password,
    String? cpf,
  }) {
    return LoginEntity(
      email: email ?? '$validCpfDigits@cbyk.challenge',
      password: password ?? faker.internet.password(length: 8),
      cpf: cpf ?? validCpfDigits,
    );
  }

  static RegisterEntity register({
    String? email,
    String? password,
    String? name,
    String? cpf,
  }) {
    return RegisterEntity(
      email: email ?? '$validCpfDigits@cbyk.challenge',
      password: password ?? faker.internet.password(length: 8),
      name: name ?? faker.person.name(),
      cpf: cpf ?? validCpfDigits,
    );
  }
}
