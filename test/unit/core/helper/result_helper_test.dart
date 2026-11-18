import 'package:flutter_test/flutter_test.dart';
import 'package:cbyk_flutter_challenge/core/helper/result_helper.dart';

void main() {
  group('ResultHelper', () {
    test('initial começa sem flags', () {
      const result = ResultHelper<void>.initial();
      expect(result.isLoading, isFalse);
      expect(result.isSuccess, isFalse);
      expect(result.isError, isFalse);
    });

    test('loading marca isLoading', () {
      final result = ResultHelper<void>.loading();
      expect(result.isLoading, isTrue);
    });

    test('success carrega data e mensagens', () {
      final result = ResultHelper.success(
        data: 'ok',
        titleMessage: 'Título',
        descriptionMessage: 'Descrição',
      );
      expect(result.isSuccess, isTrue);
      expect(result.data, 'ok');
      expect(result.titleMessage, 'Título');
      expect(result.descriptionMessage, 'Descrição');
    });

    test('error marca isError', () {
      final result = ResultHelper<void>.error(
        titleMessage: 'Erro',
        descriptionMessage: 'Falhou',
      );
      expect(result.isError, isTrue);
      expect(result.titleMessage, 'Erro');
    });

    test('copyWith preserva e sobrescreve campos', () {
      final result = ResultHelper.success(data: 1).copyWith(data: 2);
      expect(result.isSuccess, isTrue);
      expect(result.data, 2);

      final preserved = ResultHelper.success(data: 9).copyWith(isError: false);
      expect(preserved.data, 9);
    });
  });
}
