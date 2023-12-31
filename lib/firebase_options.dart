// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyAp9dM3q5F7VKflGdthw638ZaVR05GYDbo',
    appId: '1:1089372211692:web:b152ebbdf076a1e30d98c9',
    messagingSenderId: '1089372211692',
    projectId: 'noex-118ce',
    authDomain: 'noex-118ce.firebaseapp.com',
    storageBucket: 'noex-118ce.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAcsC-XeuXjjQnBbiwFncQ7SDx_bHpf9Pk',
    appId: '1:1089372211692:android:ad6a91bf829a73150d98c9',
    messagingSenderId: '1089372211692',
    projectId: 'noex-118ce',
    storageBucket: 'noex-118ce.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBaWyyNPQz-NyxV4O6eCW53Gy2NWC6eUp8',
    appId: '1:1089372211692:ios:c90643431ad610ea0d98c9',
    messagingSenderId: '1089372211692',
    projectId: 'noex-118ce',
    storageBucket: 'noex-118ce.appspot.com',
    iosBundleId: 'noexis.noexisTask',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBaWyyNPQz-NyxV4O6eCW53Gy2NWC6eUp8',
    appId: '1:1089372211692:ios:639f8c99ebc46fc60d98c9',
    messagingSenderId: '1089372211692',
    projectId: 'noex-118ce',
    storageBucket: 'noex-118ce.appspot.com',
    iosBundleId: 'noexis.noexisTask.RunnerTests',
  );
}
