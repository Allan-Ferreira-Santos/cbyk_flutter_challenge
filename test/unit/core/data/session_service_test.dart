import 'package:flutter_test/flutter_test.dart';
import 'package:cbyk_flutter_challenge/core/data/services/session_service.dart';

import '../../../support/fixtures.dart';

void main() {
  group('SessionService', () {
    test('inicia sem usuário autenticado', () {
      final session = SessionService();
      expect(session.currentUser, isNull);
      expect(session.isAuthenticated, isFalse);
    });

    test('setUser e clear atualizam sessão', () {
      final session = SessionService();
      final user = TestFixtures.user();

      session.setUser(user);
      expect(session.isAuthenticated, isTrue);
      expect(session.currentUser?.id, user.id);

      session.clear();
      expect(session.currentUser, isNull);
      expect(session.isAuthenticated, isFalse);
    });
  });
}
