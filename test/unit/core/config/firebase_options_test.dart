import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cbyk_flutter_challenge/firebase_options.dart';

void main() {
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  test('android e iOS usam as opções da própria plataforma', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    expect(DefaultFirebaseOptions.currentPlatform, DefaultFirebaseOptions.android);

    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    expect(DefaultFirebaseOptions.currentPlatform, DefaultFirebaseOptions.ios);
  });

  test('as opções compartilham o mesmo projeto Firebase', () {
    expect(DefaultFirebaseOptions.web.projectId, 'cbyk-flutter-challenge');
    expect(DefaultFirebaseOptions.android.projectId, 'cbyk-flutter-challenge');
    expect(DefaultFirebaseOptions.ios.projectId, 'cbyk-flutter-challenge');
    expect(DefaultFirebaseOptions.ios.iosBundleId, isNotEmpty);
  });

  for (final platform in [
    TargetPlatform.macOS,
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.fuchsia,
  ]) {
    test('plataforma ${platform.name} não suportada lança UnsupportedError', () {
      debugDefaultTargetPlatformOverride = platform;

      expect(
        () => DefaultFirebaseOptions.currentPlatform,
        throwsUnsupportedError,
      );
    });
  }
}
