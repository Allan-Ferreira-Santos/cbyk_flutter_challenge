import 'package:flutter_test/flutter_test.dart';
import 'package:cbyk_flutter_challenge/features/register/data/models/register_model.dart';
import 'package:cbyk_flutter_challenge/features/register/data/models/register_profile_model.dart';

import '../../../../support/fixtures.dart';

void main() {
  test('RegisterModel roundtrip', () {
    final entity = TestFixtures.register();
    final model = RegisterModel.fromEntity(entity);
    final json = model.toJson();
    final parsed = RegisterModel.fromJson(json);

    expect(parsed.name, entity.name);
    expect(parsed.cpf, entity.cpf);
  });

  test('RegisterProfileModel roundtrip', () {
    final model = RegisterProfileModel.fromJson({
      'id': '1',
      'name': 'Allan',
      'cpf': '52998224725',
      'email': 'a@b.c',
    });
    final entity = model.toEntity();
    expect(entity.name, 'Allan');
    expect(model.toJson()['email'], 'a@b.c');
  });
}
