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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      // case TargetPlatform.iOS:
      //   return ios;
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
    apiKey: 'AIzaSyBYog6l-EwGc085OUx1lfoSp2eIp9qbtnU',
    appId: '1:383218072411:android:3da8e40d027517d5a4787e',
    messagingSenderId: '383218072411',
    projectId: 'springrain-quizzy-b27a4',
    storageBucket: 'springrain-quizzy-b27a4.appspot.com',
  );

  // static const FirebaseOptions ios = FirebaseOptions(
  //   apiKey: 'AIzaSyBETUOGTr6nNY4F4ZMNta29hlW-9l1kPRI',
  //   appId: '1:208095620232:android:d391f6e1a122170f21c33d',
  //   messagingSenderId: '208095620232',
  //   projectId: 'springrain-quizzy',
  //   storageBucket: 'springrain-quizzy.appspot.com',
  //   androidClientId:
  //       '523404024585-llm65p9gefh96qaiun5dlu3t46n6udlb.apps.googleusercontent.com',
  //   iosClientId:
  //       '733623030521-0gefiutja9tmk8u0vmnbnlf2a1733i44.apps.googleusercontent.com',
  //   iosBundleId: 'com.springrain.quizzy',
  // );
}
