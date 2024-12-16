import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web; // Return web options if running on the web
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.android:
        return android;
      case TargetPlatform.macOS:
        return macos;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: 'YOUR_WEB_APP_ID',
    messagingSenderId: 'YOUR_WEB_MESSAGING_SENDER_ID',
    projectId: 'YOUR_WEB_PROJECT_ID',
    storageBucket: 'YOUR_WEB_STORAGE_BUCKET',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAt0KoJTPAylBR703t3n1gCcYaqoxTdBWA',
    appId: '1:894264756824:android:1e26a6f5b276019fc1982d',
    messagingSenderId: '894264756824',
    projectId: 'chordify-7c8a9',
    storageBucket: 'chordify-7c8a9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyASPu_p7WqU5LwmuLoZ8vAYkesAZDYBp0c',
    appId: '1:165047856169:ios:5330d46fa173c486238038',
    messagingSenderId: '165047856169',
    projectId: 'chordifynew',
    storageBucket: 'chordifynew.appspot.com',
    iosBundleId: 'com.example.chordify',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR_MACOS_API_KEY',
    appId: 'YOUR_MACOS_APP_ID',
    messagingSenderId: 'YOUR_MACOS_MESSAGING_SENDER_ID',
    projectId: 'YOUR_MACOS_PROJECT_ID',
    storageBucket: 'YOUR_MACOS_STORAGE_BUCKET',
  );
}
