import 'package:flutter_test/flutter_test.dart';
import 'package:cbyk_flutter_challenge/core/config/responsive/app_responsive.dart';

void main() {
  group('AppResponsive', () {
    test('classifica mobile/tablet/desktop', () {
      expect(AppResponsive.fromWidth(320).isMobile, isTrue);
      expect(AppResponsive.fromWidth(700).isTablet, isTrue);
      expect(AppResponsive.fromWidth(1200).isDesktop, isTrue);
    });

    test('when retorna valor por breakpoint', () {
      expect(
        AppResponsive.fromWidth(320).when(
          mobile: 'm',
          tablet: 't',
          desktop: 'd',
        ),
        'm',
      );
      expect(
        AppResponsive.fromWidth(700).when(
          mobile: 'm',
          tablet: 't',
          desktop: 'd',
        ),
        't',
      );
      expect(
        AppResponsive.fromWidth(1200).when(
          mobile: 'm',
          desktop: 'd',
        ),
        'd',
      );
    });
  });
}
