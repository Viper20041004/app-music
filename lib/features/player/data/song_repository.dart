import 'package:app_music/core/network/api_constants.dart';
import 'package:app_music/features/main_page/library/data/song_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class SongRepository {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {
        'Accept': 'application/json',
      },
    ),
  );

  static const List<SongModel> fallbackSongs = [];

  /// Gọi API lấy danh sách bài hát từ http://localhost:3000/songs
  /// Tự động xử lý địa chỉ máy host (10.0.2.2) khi chạy trên Android Emulator.
  Future<List<SongModel>> fetchSongs({String? query}) async {
    final candidateHosts = <String>[];
    final defaultBase = ApiConstants.defaultBaseUrl;
    candidateHosts.add(defaultBase);

    // Nếu default là 10.0.2.2 thì thêm localhost:3000 làm fallback (và ngược lại)
    if (defaultBase.contains('10.0.2.2')) {
      candidateHosts.add('http://localhost:3000');
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      candidateHosts.add('http://10.0.2.2:3000');
    }

    for (final host in candidateHosts) {
      final endpoint = '$host/songs';
      try {
        debugPrint('Fetching songs from API: $endpoint');
        final response = await _dio.get(endpoint);

        if (response.statusCode == 200 && response.data != null) {
          final dynamic rawData = response.data;
          List<dynamic> list;
          if (rawData is List) {
            list = rawData;
          } else if (rawData is Map && rawData['data'] is List) {
            list = rawData['data'] as List;
          } else if (rawData is Map && rawData['results'] is List) {
            list = rawData['results'] as List;
          } else {
            list = [];
          }

          final List<SongModel> songs = list
              .whereType<Map<String, dynamic>>()
              .map((item) => SongModel.fromJson(item, baseUrl: host))
              .toList();

          debugPrint('Successfully fetched ${songs.length} songs from $endpoint');

          if (query != null && query.trim().isNotEmpty) {
            final q = query.toLowerCase().trim();
            return songs.where((s) {
              return s.title.toLowerCase().contains(q) ||
                  s.artist.toLowerCase().contains(q);
            }).toList();
          }

          return songs;
        }
      } catch (e) {
        debugPrint('Error fetching songs from $endpoint: $e');
      }
    }

    debugPrint('Fallback to default sample songs because API request failed');
    return fallbackSongs;
  }
}
