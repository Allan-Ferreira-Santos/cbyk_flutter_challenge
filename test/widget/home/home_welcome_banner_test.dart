import 'package:flutter_test/flutter_test.dart';
import 'package:cbyk_flutter_challenge/features/home/presentation/widgets/home_welcome_banner.dart';
import 'package:cbyk_flutter_challenge/features/home/utils/mappers/home_page_mapper.dart';

import '../../support/fixtures.dart';
import '../../support/pump_app.dart';

void main() {
  testWidgets('mostra bem-vindo e nome em linhas separadas', (tester) async {
    final user = TestFixtures.user(name: 'Allan Ferreira');

    await tester.pumpScaffold(HomeWelcomeBanner(userName: user.name));

    expect(find.text(HomePageMapper.welcomeLabel), findsOneWidget);
    expect(find.text('Allan Ferreira'), findsOneWidget);
  });
}
