import 'package:flutter_test/flutter_test.dart';
import 'package:cbyk_flutter_challenge/features/auth/data/models/user_model.dart';

import '../../../../support/fixtures.dart';

void main() {
  group('UserModel', () {
    test('fromJson / toJson / toEntity', () {
      final user = TestFixtures.user();
      final model = UserModel.fromEntity(user);
      final json = model.toJson();
      final parsed = UserModel.fromJson(json);
      final entity = parsed.toEntity();

      expect(json['id'], user.id);
      expect(parsed.email, user.email);
      expect(entity.name, user.name);
    });

    test('fromJson usa defaults para campos ausentes', () {
      final model = UserModel.fromJson({});
      expect(model.id, '');
      expect(model.name, '');
      expect(model.cpf, '');
      expect(model.email, '');
    });
  });
}
