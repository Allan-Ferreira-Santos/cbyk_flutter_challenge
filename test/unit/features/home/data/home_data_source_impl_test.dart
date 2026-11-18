import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cbyk_flutter_challenge/features/home/data/data_source/home_data_source_impl.dart';

import '../../../../support/mocks.dart';

void main() {
  late MockFirebaseAuth auth;

  setUp(() {
    auth = MockFirebaseAuth();
    when(() => auth.signOut()).thenAnswer((_) async {});
  });

  test('signOut delega para FirebaseAuth', () async {
    final dataSource = HomeDataSourceImpl(auth: auth);
    await dataSource.signOut();
    verify(() => auth.signOut()).called(1);
  });
}
