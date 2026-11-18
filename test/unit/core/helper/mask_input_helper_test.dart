import 'package:flutter_test/flutter_test.dart';
import 'package:cbyk_flutter_challenge/core/helper/mask_input_helper.dart';

import '../../../support/fixtures.dart';

void main() {
  group('MaskInputHelper', () {
    test('unmaskCpf remove máscara', () {
      expect(
        MaskInputHelper.unmaskCpf(TestFixtures.validCpfMasked),
        TestFixtures.validCpfDigits,
      );
    });

    test('formatCpf aplica máscara', () {
      expect(
        MaskInputHelper.formatCpf(TestFixtures.validCpfDigits),
        TestFixtures.validCpfMasked,
      );
    });

    test('formatCpf retorna vazio para nulo ou vazio', () {
      expect(MaskInputHelper.formatCpf(null), '');
      expect(MaskInputHelper.formatCpf(''), '');
    });

    test('cpfMaskWithInitial cria formatter', () {
      final mask = MaskInputHelper.cpfMaskWithInitial(
        TestFixtures.validCpfDigits,
      );
      expect(mask.getMaskedText(), TestFixtures.validCpfMasked);
    });
  });
}
