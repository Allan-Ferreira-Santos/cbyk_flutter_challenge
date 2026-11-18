import 'package:cbyk_flutter_challenge/core/utils/mappers/app_message_exception_mapper.dart';

class AppException implements Exception {
  final String message;
  final String? code;
  final String? error;

  const AppException(
    this.message, {
    this.code,
    this.error,
  });

  @override
  String toString() => message;

  factory AppException.fromMap(Map<String, dynamic> map) => AppException(
        validateMessage(map['message']),
        code: map['code'] as String?,
        error: map['error'] as String?,
      );

  static String validateMessage(
    dynamic message, [
    String defaultMessage = AppMessageExceptionMapper.unknownError,
  ]) {
    if (message == null) return defaultMessage;
    if (message is String) return message;
    if (message is List && message.isNotEmpty) return message.first.toString();
    if (message is Map) {
      return message['error']?.toString() ?? defaultMessage;
    }
    return defaultMessage;
  }
}

class UnauthorizedException extends AppException {
  const UnauthorizedException(super.message)
      : super(code: 'unauthorized');
}

class NotFoundException extends AppException {
  const NotFoundException(super.message) : super(code: 'not-found');
}

class BadRequestException extends AppException {
  const BadRequestException(super.message) : super(code: 'bad-request');
}

class PermissionDeniedException extends AppException {
  const PermissionDeniedException(super.message)
      : super(code: 'permission-denied');
}

class AlreadyExistsException extends AppException {
  const AlreadyExistsException(super.message)
      : super(code: 'already-exists');
}

class NetworkException extends AppException {
  const NetworkException(super.message) : super(code: 'network-error');
}

class UnavailableException extends AppException {
  const UnavailableException(super.message) : super(code: 'unavailable');
}

class TimeoutException extends AppException {
  const TimeoutException(super.message) : super(code: 'timeout');
}

class InternalException extends AppException {
  const InternalException(super.message) : super(code: 'internal');
}

class CancelledException extends AppException {
  const CancelledException(super.message) : super(code: 'cancelled');
}
