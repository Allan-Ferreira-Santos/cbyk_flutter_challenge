import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cbyk_flutter_challenge/core/exceptions/app_exception.dart';
import 'package:cbyk_flutter_challenge/core/helper/firebase_exception_helper.dart';
import 'package:cbyk_flutter_challenge/core/utils/mappers/app_message_exception_mapper.dart';

void main() {
  group('FirebaseExceptionHelper.fromAuth', () {
    test('mapeia códigos conhecidos', () {
      expect(
        FirebaseExceptionHelper.fromAuth(
          FirebaseAuthException(code: 'invalid-email'),
        ),
        isA<BadRequestException>(),
      );
      expect(
        FirebaseExceptionHelper.fromAuth(
          FirebaseAuthException(code: 'user-disabled'),
        ),
        isA<UnauthorizedException>(),
      );
      expect(
        FirebaseExceptionHelper.fromAuth(
          FirebaseAuthException(code: 'wrong-password'),
        ),
        isA<UnauthorizedException>(),
      );
      expect(
        FirebaseExceptionHelper.fromAuth(
          FirebaseAuthException(code: 'email-already-in-use'),
        ),
        isA<AlreadyExistsException>(),
      );
      expect(
        FirebaseExceptionHelper.fromAuth(
          FirebaseAuthException(code: 'weak-password'),
        ),
        isA<BadRequestException>(),
      );
      expect(
        FirebaseExceptionHelper.fromAuth(
          FirebaseAuthException(code: 'user-not-found'),
        ),
        isA<UnauthorizedException>(),
      );
      expect(
        FirebaseExceptionHelper.fromAuth(
          FirebaseAuthException(code: 'invalid-credential'),
        ),
        isA<UnauthorizedException>(),
      );
      expect(
        FirebaseExceptionHelper.fromAuth(
          FirebaseAuthException(code: 'operation-not-allowed'),
        ),
        isA<BadRequestException>(),
      );
      expect(
        FirebaseExceptionHelper.fromAuth(
          FirebaseAuthException(
            code: 'account-exists-with-different-credential',
          ),
        ),
        isA<AlreadyExistsException>(),
      );
      expect(
        FirebaseExceptionHelper.fromAuth(
          FirebaseAuthException(code: 'cancelled-popup-request'),
        ),
        isA<CancelledException>(),
      );
      expect(
        FirebaseExceptionHelper.fromAuth(
          FirebaseAuthException(code: 'popup-closed-by-user'),
        ),
        isA<CancelledException>(),
      );
      expect(
        FirebaseExceptionHelper.fromAuth(
          FirebaseAuthException(code: 'network-request-failed'),
        ),
        isA<NetworkException>(),
      );
      expect(
        FirebaseExceptionHelper.fromAuth(
          FirebaseAuthException(code: 'too-many-requests'),
        ),
        isA<UnavailableException>(),
      );
    });

    test('default usa message ou fallback', () {
      final withMessage = FirebaseExceptionHelper.fromAuth(
        FirebaseAuthException(code: 'custom', message: 'custom msg'),
      );
      expect(withMessage.message, 'custom msg');

      final withoutMessage = FirebaseExceptionHelper.fromAuth(
        FirebaseAuthException(code: 'custom'),
      );
      expect(
        withoutMessage.message,
        contains(AppMessageExceptionMapper.authFailed),
      );
    });
  });

  group('FirebaseExceptionHelper.fromFirestore', () {
    test('mapeia códigos conhecidos', () {
      expect(
        FirebaseExceptionHelper.fromFirestore(
          FirebaseException(plugin: 'firestore', code: 'permission-denied'),
        ),
        isA<PermissionDeniedException>(),
      );
      expect(
        FirebaseExceptionHelper.fromFirestore(
          FirebaseException(plugin: 'firestore', code: 'not-found'),
        ),
        isA<NotFoundException>(),
      );
      expect(
        FirebaseExceptionHelper.fromFirestore(
          FirebaseException(plugin: 'firestore', code: 'deadline-exceeded'),
        ),
        isA<TimeoutException>(),
      );
      expect(
        FirebaseExceptionHelper.fromFirestore(
          FirebaseException(plugin: 'firestore', code: 'cancelled'),
        ),
        isA<CancelledException>(),
      );
      expect(
        FirebaseExceptionHelper.fromFirestore(
          FirebaseException(plugin: 'firestore', code: 'already-exists'),
        ),
        isA<AlreadyExistsException>(),
      );
      expect(
        FirebaseExceptionHelper.fromFirestore(
          FirebaseException(plugin: 'firestore', code: 'unavailable'),
        ),
        isA<UnavailableException>(),
      );
      expect(
        FirebaseExceptionHelper.fromFirestore(
          FirebaseException(plugin: 'firestore', code: 'unauthenticated'),
        ),
        isA<UnauthorizedException>(),
      );
      expect(
        FirebaseExceptionHelper.fromFirestore(
          FirebaseException(
            plugin: 'firestore',
            code: 'custom',
            message: 'fs',
          ),
        ).message,
        'fs',
      );
    });
  });

  group('FirebaseExceptionHelper.fromAny', () {
    test('repassa AppException e converte demais', () {
      const app = UnauthorizedException('x');
      expect(FirebaseExceptionHelper.fromAny(app), same(app));

      expect(
        FirebaseExceptionHelper.fromAny(
          FirebaseAuthException(code: 'invalid-email'),
        ),
        isA<BadRequestException>(),
      );

      expect(
        FirebaseExceptionHelper.fromAny(
          FirebaseException(plugin: 'firestore', code: 'not-found'),
        ),
        isA<NotFoundException>(),
      );

      final generic = FirebaseExceptionHelper.fromAny(Exception('boom'));
      expect(generic.message, 'boom');
    });
  });
}
