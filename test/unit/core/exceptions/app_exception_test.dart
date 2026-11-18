import 'package:flutter_test/flutter_test.dart';
import 'package:cbyk_flutter_challenge/core/exceptions/app_exception.dart';
import 'package:cbyk_flutter_challenge/core/utils/mappers/app_message_exception_mapper.dart';

void main() {
  group('AppException', () {
    test('toString retorna message', () {
      const exception = AppException('falhou');
      expect(exception.toString(), 'falhou');
    });

    test('fromMap lê message string', () {
      final exception = AppException.fromMap({'message': 'erro', 'code': 'x'});
      expect(exception.message, 'erro');
      expect(exception.code, 'x');
    });

    test('validateMessage cobre tipos', () {
      expect(
        AppException.validateMessage(null),
        AppMessageExceptionMapper.unknownError,
      );
      expect(AppException.validateMessage('ok'), 'ok');
      expect(AppException.validateMessage(['a', 'b']), 'a');
      expect(
        AppException.validateMessage({'error': 'map'}),
        'map',
      );
      expect(
        AppException.validateMessage(123),
        AppMessageExceptionMapper.unknownError,
      );
    });

    test('subclasses definem códigos', () {
      expect(const UnauthorizedException('u').code, 'unauthorized');
      expect(const NotFoundException('n').code, 'not-found');
      expect(const BadRequestException('b').code, 'bad-request');
      expect(const PermissionDeniedException('p').code, 'permission-denied');
      expect(const AlreadyExistsException('a').code, 'already-exists');
      expect(const NetworkException('n').code, 'network-error');
      expect(const UnavailableException('u').code, 'unavailable');
      expect(const TimeoutException('t').code, 'timeout');
      // instanciação não-const para o construtor contar na cobertura
      expect(InternalException('i').code, 'internal');
      expect(const CancelledException('c').code, 'cancelled');
    });

    test('validateMessage usa default customizado e map sem error', () {
      expect(
        AppException.validateMessage(null, 'custom'),
        'custom',
      );
      expect(
        AppException.validateMessage(<String, dynamic>{}),
        AppMessageExceptionMapper.unknownError,
      );
      expect(AppException.validateMessage(<dynamic>[]), AppMessageExceptionMapper.unknownError);
    });
  });
}
