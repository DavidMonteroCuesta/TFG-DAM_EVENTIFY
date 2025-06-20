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
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBY5WqXr-Flz3qkCJ-JuOrX9gZIVz1xNR4',
    appId: '1:261209819802:web:bd4794ecd7c80c59ff6d23',
    messagingSenderId: '261209819802',
    projectId: 'eventify-16edb',
    authDomain: 'eventify-16edb.firebaseapp.com',
    storageBucket: 'eventify-16edb.firebasestorage.app',
    measurementId: 'G-G45L3TYPH6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDokaG8WboIrGJlSWjQjIxM-xdOPhUzlFM',
    appId: '1:261209819802:android:77869357e65cefe9ff6d23',
    messagingSenderId: '261209819802',
    projectId: 'eventify-16edb',
    storageBucket: 'eventify-16edb.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAH53qXdvNQT03J4u9_j0MGDLrC9E5vEjk',
    appId: '1:261209819802:ios:7205645a1dbaf3c2ff6d23',
    messagingSenderId: '261209819802',
    projectId: 'eventify-16edb',
    storageBucket: 'eventify-16edb.firebasestorage.app',
    iosClientId: '261209819802-s5dfg1gsk10i3gdhe25d5khqiee1bi6l.apps.googleusercontent.com',
    iosBundleId: 'com.example.eventify',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAH53qXdvNQT03J4u9_j0MGDLrC9E5vEjk',
    appId: '1:261209819802:ios:7205645a1dbaf3c2ff6d23',
    messagingSenderId: '261209819802',
    projectId: 'eventify-16edb',
    storageBucket: 'eventify-16edb.firebasestorage.app',
    iosClientId: '261209819802-s5dfg1gsk10i3gdhe25d5khqiee1bi6l.apps.googleusercontent.com',
    iosBundleId: 'com.example.eventify',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBY5WqXr-Flz3qkCJ-JuOrX9gZIVz1xNR4',
    appId: '1:261209819802:web:08347f04cddbbad3ff6d23',
    messagingSenderId: '261209819802',
    projectId: 'eventify-16edb',
    authDomain: 'eventify-16edb.firebaseapp.com',
    storageBucket: 'eventify-16edb.firebasestorage.app',
    measurementId: 'G-CB5B7FNDHQ',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyBY5WqXr-Flz3qkCJ-JuOrX9gZIVz1xNR4',
    appId: '1:261209819802:web:bd4794ecd7c80c59ff6d23',
    messagingSenderId: '261209819802',
    projectId: 'eventify-16edb',
    authDomain: 'eventify-16edb.firebaseapp.com',
    storageBucket: 'eventify-16edb.firebasestorage.app',
    measurementId: 'G-G45L3TYPH6',
  );
}