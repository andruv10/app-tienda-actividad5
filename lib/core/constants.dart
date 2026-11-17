import 'package:flutter/foundation.dart' show kIsWeb;
import 'app_url.dart';

class AppConstants {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    }
    return getNativeApiUrl();
  }
}
