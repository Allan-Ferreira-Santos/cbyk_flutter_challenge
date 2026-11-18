import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cbyk_flutter_challenge/core/data/services/preferences_service.dart';

import '../../../support/fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PreferencesService', () {
    late PreferencesService preferences;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      preferences = PreferencesService(await SharedPreferences.getInstance());
    });

    test('rememberAlways padrão é false', () {
      expect(preferences.rememberAlways, isFalse);
    });

    test('persiste rememberAlways e CPF', () async {
      await preferences.setRememberAlways(true);
      await preferences.setSavedCpf(TestFixtures.validCpfDigits);

      expect(preferences.rememberAlways, isTrue);
      expect(preferences.savedCpf, TestFixtures.validCpfDigits);
    });

    test('remove CPF quando nulo ou vazio', () async {
      await preferences.setSavedCpf(TestFixtures.validCpfDigits);
      await preferences.setSavedCpf(null);
      expect(preferences.savedCpf, isNull);

      await preferences.setSavedCpf(TestFixtures.validCpfDigits);
      await preferences.setSavedCpf('');
      expect(preferences.savedCpf, isNull);
    });
  });
}
