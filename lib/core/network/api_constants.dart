class ApiConstants {
  static const String defaultBaseUrl =
      'https://musium-backend.onrender.com';

  static String get songsEndpoint => '$defaultBaseUrl/songs';
  static String get searchSongsEndpoint => '$defaultBaseUrl/songs/search';
}
