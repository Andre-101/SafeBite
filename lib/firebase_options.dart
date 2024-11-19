// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDGNVnnoKOXvki2GE7WwvH8AUBqwl6svb4',
    appId: '1:1004401762155:android:d34d4537da7d9cb75cf62e',
    messagingSenderId: '1004401762155',
    projectId: 'safebite-f5e89',
    storageBucket: 'safebite-f5e89.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyBuU5lR6dtzT_uJgDArxOgKtOFdX7B-piU",
    authDomain: "safebite-f5e89.firebaseapp.com",
    projectId: "safebite-f5e89",
    storageBucket: "safebite-f5e89.firebasestorage.app",
    messagingSenderId: "1004401762155",
    appId: "1:1004401762155:web:fbf892fbd0c479445cf62e",
    measurementId: "G-Y5WZQJYRDB"
  );
}
