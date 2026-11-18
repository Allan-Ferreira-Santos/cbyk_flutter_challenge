import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAKBYfqm9S06TaEkgtjh1EBcijJbMN7Pqo',
    appId: '1:869666534879:web:8d105d2eb75190345f806a',
    messagingSenderId: '869666534879',
    projectId: 'cbyk-flutter-challenge',
    authDomain: 'cbyk-flutter-challenge.firebaseapp.com',
    storageBucket: 'cbyk-flutter-challenge.firebasestorage.app',
    measurementId: 'G-TG0RRPQ5MH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCTHV6BJVAZDND3bEtjFOyNurht3fG8upc',
    appId: '1:869666534879:android:d0f7fe62a0bbbf5b5f806a',
    messagingSenderId: '869666534879',
    projectId: 'cbyk-flutter-challenge',
    storageBucket: 'cbyk-flutter-challenge.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCHJuLQ_X9NLIuv5vNm45r6U6vhMISc9jI',
    appId: '1:869666534879:ios:7e87485d5fb7e3765f806a',
    messagingSenderId: '869666534879',
    projectId: 'cbyk-flutter-challenge',
    storageBucket: 'cbyk-flutter-challenge.firebasestorage.app',
    iosClientId: '869666534879-ojo3o85fb1q90j4dd7i6ivhe056fn737.apps.googleusercontent.com',
    iosBundleId: 'br.com.cbyk.cbykFlutterChallenge',
  );
}
