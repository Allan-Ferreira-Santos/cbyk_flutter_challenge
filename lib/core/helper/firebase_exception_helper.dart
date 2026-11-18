import 'package:firebase_auth/firebase_auth.dart';
import 'package:cbyk_flutter_challenge/core/exceptions/app_exception.dart';
import 'package:cbyk_flutter_challenge/core/utils/mappers/app_message_exception_mapper.dart';


abstract class FirebaseExceptionHelper {
  static AppException fromAuth(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return const BadRequestException(
          AppMessageExceptionMapper.invalidEmail,
        );
      case 'user-disabled':
        return const UnauthorizedException(
          AppMessageExceptionMapper.userDisabled,
        );
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return const UnauthorizedException(
          AppMessageExceptionMapper.unauthorized,
        );
      case 'email-already-in-use':
        return const AlreadyExistsException(
          AppMessageExceptionMapper.alreadyExists,
        );
      case 'weak-password':
        return const BadRequestException(
          AppMessageExceptionMapper.weakPassword,
        );
      case 'operation-not-allowed':
        return const BadRequestException(
          AppMessageExceptionMapper.operationNotAllowed,
        );
      case 'account-exists-with-different-credential':
        return const AlreadyExistsException(
          AppMessageExceptionMapper.accountExistsWithDifferentCredential,
        );
      case 'popup-closed-by-user':
      case 'cancelled-popup-request':
        return const CancelledException(
          AppMessageExceptionMapper.googleCancelled,
        );
      case 'too-many-requests':
        return const UnavailableException(
          AppMessageExceptionMapper.tooManyRequests,
        );
      case 'network-request-failed':
        return const NetworkException(AppMessageExceptionMapper.networkError);
      default:
        return AppException(
          exception.message?.isNotEmpty == true
              ? exception.message!
              : '${AppMessageExceptionMapper.authFailed} (${exception.code})',
          code: exception.code,
          error: exception.message,
        );
    }
  }

  static AppException fromFirestore(FirebaseException exception) {
    switch (exception.code) {
      case 'permission-denied':
        return const PermissionDeniedException(
          AppMessageExceptionMapper.permissionDenied,
        );
      case 'not-found':
        return const NotFoundException(AppMessageExceptionMapper.notFound);
      case 'already-exists':
        return const AlreadyExistsException(
          AppMessageExceptionMapper.alreadyExists,
        );
      case 'unavailable':
        return const UnavailableException(
          AppMessageExceptionMapper.unavailable,
        );
      case 'deadline-exceeded':
        return const TimeoutException(AppMessageExceptionMapper.timeoutError);
      case 'cancelled':
        return const CancelledException(AppMessageExceptionMapper.unknownError);
      case 'unauthenticated':
        return const UnauthorizedException(
          AppMessageExceptionMapper.unauthorized,
        );
      default:
        return AppException(
          AppException.validateMessage(
            exception.message,
            AppMessageExceptionMapper.unknownError,
          ),
          code: exception.code,
          error: exception.message,
        );
    }
  }

  static AppException fromAny(Object error) {
    if (error is AppException) return error;
    if (error is FirebaseAuthException) return fromAuth(error);
    if (error is FirebaseException) return fromFirestore(error);
    return AppException(
      AppException.validateMessage(
        error.toString().replaceFirst('Exception: ', ''),
      ),
    );
  }
}
