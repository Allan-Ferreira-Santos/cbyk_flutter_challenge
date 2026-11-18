import 'package:flutter_test/flutter_test.dart';
import 'package:cbyk_flutter_challenge/core/helper/validator_helper.dart';
import 'package:cbyk_flutter_challenge/core/utils/mappers/validate_mapper.dart';

import '../../../support/fixtures.dart';

void main() {
  group('ValidatorHelper.name', () {
    test('retorna erro quando vazio', () {
      expect(ValidatorHelper.name(null), ValidateMapper.nameEmpty);
      expect(ValidatorHelper.name(''), ValidateMapper.nameEmpty);
      expect(ValidatorHelper.name('  '), ValidateMapper.nameEmpty);
    });

    test('retorna erro quando curto', () {
      expect(ValidatorHelper.name('Al'), ValidateMapper.nameTooShort);
    });

    test('retorna erro quando inválido', () {
      expect(ValidatorHelper.name('Allan123'), ValidateMapper.nameInvalid);
    });

    test('aceita nome válido', () {
      expect(ValidatorHelper.name('Allan Ferreira'), isNull);
    });
  });

  group('ValidatorHelper.cpf', () {
    test('retorna erro quando vazio', () {
      expect(ValidatorHelper.cpf(null), ValidateMapper.cpfEmpty);
      expect(ValidatorHelper.cpf(''), ValidateMapper.cpfEmpty);
    });

    test('retorna erro quando incompleto', () {
      expect(ValidatorHelper.cpf('529.982'), ValidateMapper.cpfInvalid);
    });

    test('aceita CPF com 11 dígitos', () {
      expect(ValidatorHelper.cpf(TestFixtures.validCpfMasked), isNull);
    });
  });

  group('ValidatorHelper.password', () {
    test('retorna erro quando vazia', () {
      expect(ValidatorHelper.password(null), ValidateMapper.passwordEmpty);
      expect(ValidatorHelper.password(''), ValidateMapper.passwordEmpty);
    });

    test('retorna erro quando curta', () {
      expect(ValidatorHelper.password('12345'), ValidateMapper.passwordLength);
    });

    test('aceita senha válida', () {
      expect(ValidatorHelper.password('123456'), isNull);
    });
  });
}
