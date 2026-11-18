import 'package:flutter_test/flutter_test.dart';
import 'package:cbyk_flutter_challenge/core/config/app_config.dart';

import '../../../support/fixtures.dart';

void main() {
  test('emailFromCpf gera email do desafio', () {
    expect(
      AppConfig.emailFromCpf(TestFixtures.validCpfDigits),
      '${TestFixtures.validCpfDigits}@cbyk.challenge',
    );
  });

  test('webviewAutomovelUrl está definida', () {
    expect(AppConfig.webviewAutomovelUrl, contains('https://'));
  });
}
