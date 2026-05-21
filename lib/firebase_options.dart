// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Firebase Options (Auto-Generated Placeholder)
// ═══════════════════════════════════════════════════════════════════════════

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: '1:YOUR_APP_ID:web:YOUR_HASH',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'pusula-proje',
    authDomain: 'pusula-proje.firebaseapp.com',
    storageBucket: 'pusula-proje.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: '1:YOUR_APP_ID:android:YOUR_HASH',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'pusula-proje',
    storageBucket: 'pusula-proje.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: '1:YOUR_APP_ID:ios:YOUR_HASH',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'pusula-proje',
    storageBucket: 'pusula-proje.appspot.com',
    iosBundleId: 'com.example.pusula',
  );
}


