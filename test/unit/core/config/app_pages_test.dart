import 'package:flutter_test/flutter_test.dart';
import 'package:cbyk_flutter_challenge/core/config/routes/app_pages.dart';
import 'package:cbyk_flutter_challenge/core/config/routes/app_routes_mapper.dart';

void main() {
  test('AppPages expõe todas as rotas', () {
    final names = AppPages.pages.map((page) => page.name).toSet();

    expect(names, containsAll([
      AppRoutesMapper.splash,
      AppRoutesMapper.login,
      AppRoutesMapper.register,
      AppRoutesMapper.home,
      AppRoutesMapper.webview,
      AppRoutesMapper.placeholder,
    ]));

    for (final page in AppPages.pages) {
      expect(page.page(), isNotNull);
    }
  });
}
