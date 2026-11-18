import 'package:flutter_test/flutter_test.dart';
import 'package:cbyk_flutter_challenge/features/auth/data/models/login_model.dart';

import '../../../../support/fixtures.dart';

void main() {
  test('LoginModel fromEntity/fromJson/toJson', () {
    final entity = TestFixtures.login();
    final model = LoginModel.fromEntity(entity);
    final json = model.toJson();
    final parsed = LoginModel.fromJson(json);

    expect(parsed.email, entity.email);
    expect(parsed.password, entity.password);
    expect(parsed.cpf, entity.cpf);
    expect(LoginModel.fromJson({}).email, '');
  });
}
