import 'package:flutter_test/flutter_test.dart';
import 'package:cbyk_flutter_challenge/features/splash/data/models/splash_user_model.dart';

void main() {
  test('SplashUserModel roundtrip', () {
    final model = SplashUserModel.fromJson({
      'id': '1',
      'name': 'Allan',
      'cpf': '52998224725',
      'email': 'a@b.c',
    });
    expect(model.toEntity().name, 'Allan');
    expect(model.toJson()['id'], '1');
  });
}
