import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;

const _definedBase = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: '',
);

String resolveBaseUrl() {
  // Si viene desde --dart-define, usamos eso (producción)
  if (_definedBase.isNotEmpty) return _definedBase.trim();

  // Dev: si es web sin definir nada → backend local
  if (kIsWeb) return 'http://127.0.0.1:8000';

  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return 'http://10.0.2.2:8000'; // emulador Android
    case TargetPlatform.iOS:
      return 'http://127.0.0.1:8000'; // iOS Simulator
    default:
      return 'http://127.0.0.1:8000'; // desktop dev
  }
}

/*
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;

const _definedBase = String.fromEnvironment('API_BASE_URL');

String resolveBaseUrl() {
  if (_definedBase.isNotEmpty) return _definedBase.trim();

  if (kIsWeb) return 'http://127.0.0.1:8000'; // antes: localhost
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return 'http://10.0.2.2:8000';         // emulador Android
    case TargetPlatform.iOS:
      return 'http://127.0.0.1:8000';        // iOS Simulator
    default:
      return 'http://127.0.0.1:8000';
  }
}
*/