import 'package:flutter/foundation.dart';

class ApiConstants {
  // Máy host (máy tính) chạy server Node/Go/Python ở port 3000.
  // Khi chạy trên máy ảo Android (Emulator), 10.0.2.2 trỏ về localhost của máy tính host.
  // Khi chạy trên Windows Desktop / Web / iOS simulator, dùng localhost.
  static const String localhostHost = 'http://localhost:3000';
  static const String androidEmulatorHost = 'http://10.0.2.2:3000';

  static String get defaultBaseUrl {
    if (kIsWeb) return localhostHost;
    if (defaultTargetPlatform == TargetPlatform.android) {
      return androidEmulatorHost;
    }
    return localhostHost;
  }

  static String get songsEndpoint => '$defaultBaseUrl/songs';
}
