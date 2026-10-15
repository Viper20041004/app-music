import 'package:app_music/core/network/api_constants.dart';
import 'package:app_music/features/main_page/library/data/song_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class SongRepository {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
      },
    ),
  );

  static const List<SongModel> fallbackSongs = [];

  /// Gọi API lấy danh sách bài hát hoặc tìm kiếm bài hát theo từ khóa query:
  /// - Nếu có query (ví dụ: 'em'): gọi https://musium-backend.onrender.com/songs/search?q=em
  /// - Nếu không có query: gọi https://musium-backend.onrender.com/songs
  Future<List<SongModel>> fetchSongs({String? query}) async {
    final candidateHosts = <String>[];
    final defaultBase = ApiConstants.defaultBaseUrl;
    candidateHosts.add(defaultBase);

    // Thêm fallback local nếu cấu hình đang chạy ở localhost
    if (defaultBase.contains('10.0.2.2')) {
      candidateHosts.add('http://localhost:3000');
    } else if (defaultTargetPlatform == TargetPlatform.android && defaultBase.contains('localhost')) {
      candidateHosts.add('http://10.0.2.2:3000');
    }

    final hasQuery = query != null && query.trim().isNotEmpty;
    final cleanQuery = query?.trim();

    for (final host in candidateHosts) {
      final endpoint = hasQuery ? '$host/songs/search' : '$host/songs';
      final queryParams = hasQuery ? {'q': cleanQuery} : null;

      try {
        debugPrint('SongRepository: Fetching songs from $endpoint (params: $queryParams)');
        final response = await _dio.get(
          endpoint,
          queryParameters: queryParams,
        );

        if (response.statusCode == 200 && response.data != null) {
          final dynamic rawData = response.data;
          List<dynamic> list = [];

          if (rawData is List) {
            list = rawData;
          } else if (rawData is Map) {
            final dataField = rawData['data'];
            if (dataField is List) {
              list = dataField;
            } else if (dataField is Map && dataField['songs'] is List) {
              list = dataField['songs'] as List;
            } else if (rawData['songs'] is List) {
              list = rawData['songs'] as List;
            } else if (rawData['results'] is List) {
              list = rawData['results'] as List;
            }
          }

          final List<SongModel> songs = list
              .whereType<Map>()
              .map((item) => SongModel.fromJson(Map<String, dynamic>.from(item), baseUrl: host))
              .toList();

          debugPrint('Successfully fetched ${songs.length} songs from $endpoint');

          return songs;
        }
      } catch (e) {
        debugPrint('Error fetching songs from $endpoint: $e');
      }
    }

    debugPrint('Fallback to default sample songs because API request failed');
    return fallbackSongs;
  }

  /// Tìm kiếm bài hát theo từ khóa query qua endpoint /songs/search?q=...
  Future<List<SongModel>> searchSongs(String query) async {
    return fetchSongs(query: query);
  }
}
