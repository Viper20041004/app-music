import 'package:app_music/core/constant/app_assets.dart';
import 'package:app_music/core/network/api_constants.dart';
import 'package:app_music/features/main_page/explore/data/explore_models.dart';
import 'package:app_music/features/main_page/library/data/song_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ExploreSearchService {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {
        'Accept': 'application/json',
      },
    ),
  );

  /// Gọi API search http://localhost:3000/songs/search?q=...
  /// Trả về ExploreSearchResult chứa songs, artists, albums.
  Future<ExploreSearchResult> search(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) {
      return const ExploreSearchResult();
    }

    final candidateHosts = <String>[];
    final defaultBase = ApiConstants.defaultBaseUrl;
    candidateHosts.add(defaultBase);

    // Xử lý fallback giữa localhost và 10.0.2.2 (cho Android Emulator)
    if (defaultBase.contains('10.0.2.2')) {
      candidateHosts.add('http://localhost:3000');
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      candidateHosts.add('http://10.0.2.2:3000');
    }

    for (final host in candidateHosts) {
      try {
        final endpoint = '$host/songs/search';
        debugPrint('ExploreSearchService: GET $endpoint?q=$cleanQuery');

        final response = await _dio.get(
          endpoint,
          queryParameters: {'q': cleanQuery},
        );

        if (response.statusCode == 200 && response.data != null) {
          final data = response.data;
          Map<dynamic, dynamic>? searchData;

          if (data is Map) {
            if (data['data'] is Map) {
              searchData = data['data'] as Map;
            } else {
              searchData = data;
            }
          }

          if (searchData != null) {
            final rawSongs = (searchData['songs'] is List) ? searchData['songs'] as List : [];
            final rawArtists = (searchData['artists'] is List) ? searchData['artists'] as List : [];
            final rawAlbums = (searchData['albums'] is List) ? searchData['albums'] as List : [];

            final songs = rawSongs
                .whereType<Map<String, dynamic>>()
                .map((item) => SongModel.fromJson(item, baseUrl: host))
                .toList();

            final artists = rawArtists
                .whereType<Map<String, dynamic>>()
                .map((item) => ExploreArtist.fromJson(item, baseUrl: host))
                .toList();

            final albums = rawAlbums
                .whereType<Map<String, dynamic>>()
                .map((item) => ExploreAlbum.fromJson(item, baseUrl: host))
                .toList();

            debugPrint(
              'ExploreSearchService: Found ${songs.length} songs, ${artists.length} artists, ${albums.length} albums',
            );

            final result = ExploreSearchResult(
              songs: songs,
              artists: artists,
              albums: albums,
            );

            if (result.isNotEmpty) {
              return result;
            }
          }
        }
      } catch (e) {
        debugPrint('ExploreSearchService error from host $host: $e');
      }
    }

    return _getFallbackSearchResult(cleanQuery);
  }

  ExploreSearchResult _getFallbackSearchResult(String query) {
    final q = query.toLowerCase().trim();

    final allArtists = [
      const ExploreArtist(
        id: 1,
        name: 'Sơn Tùng M-TP',
        imageUrl: AppAssets.artistImage7,
        description: '140322 followers',
      ),
      const ExploreArtist(
        id: 2,
        name: 'Keshi',
        imageUrl: AppAssets.artistImage4,
        description: '98420 followers',
      ),
      const ExploreArtist(
        id: 3,
        name: 'Conan Gray',
        imageUrl: AppAssets.artistImage1,
        description: '112000 followers',
      ),
      const ExploreArtist(
        id: 4,
        name: 'MCK',
        imageUrl: AppAssets.artistImage5,
        description: '89000 followers',
      ),
      const ExploreArtist(
        id: 5,
        name: 'LowG',
        imageUrl: AppAssets.artistImage6,
        description: '76000 followers',
      ),
      const ExploreArtist(
        id: 6,
        name: 'New Jeans',
        imageUrl: AppAssets.artistImage3,
        description: '230000 followers',
      ),
      const ExploreArtist(
        id: 7,
        name: 'Chase Atlantic',
        imageUrl: AppAssets.artistImage2,
        description: '64000 followers',
      ),
    ];

    final allSongs = [
      const SongModel(
        id: 101,
        title: 'Nơi Này Có Anh',
        artist: 'Sơn Tùng M-TP',
        album: 'VIVI ENM',
        imagePath: AppAssets.artistImage7,
        duration: 260,
      ),
      const SongModel(
        id: 102,
        title: 'Âm Thầm Bên Em',
        artist: 'Sơn Tùng M-TP',
        album: 'VIVI ENM',
        imagePath: AppAssets.artistImage7,
        duration: 291,
      ),
      const SongModel(
        id: 103,
        title: 'Lạc Trôi',
        artist: 'Sơn Tùng M-TP',
        album: 'VIVI ENM',
        imagePath: AppAssets.artistImage7,
        duration: 242,
      ),
      const SongModel(
        id: 104,
        title: 'Chúng Ta Của Hiện Tại',
        artist: 'Sơn Tùng M-TP',
        album: 'VIVI ENM',
        imagePath: AppAssets.artistImage7,
        duration: 301,
      ),
      const SongModel(
        id: 105,
        title: 'Chạy Ngay Đi',
        artist: 'Sơn Tùng M-TP',
        album: 'VIVI ENM',
        imagePath: AppAssets.artistImage7,
        duration: 247,
      ),
    ];

    final isSonTungQuery = q.contains('sơn') ||
        q.contains('son') ||
        q.contains('tùng') ||
        q.contains('tung') ||
        q.contains('mtp') ||
        q.contains('m-tp') ||
        q.contains('nơi này') ||
        q.contains('âm thầm');

    final filteredArtists = allArtists.where((a) {
      final name = a.name.toLowerCase();
      if (name.contains(q)) return true;
      if (isSonTungQuery && name.contains('sơn tùng')) return true;
      return false;
    }).toList();

    final filteredSongs = allSongs.where((s) {
      final title = s.title.toLowerCase();
      final artist = s.artist.toLowerCase();
      if (title.contains(q) || artist.contains(q)) return true;
      if (isSonTungQuery) return true;
      return false;
    }).toList();

    if (filteredArtists.isEmpty && isSonTungQuery) {
      filteredArtists.add(allArtists.first);
    }

    if (filteredArtists.isEmpty && filteredSongs.isEmpty) {
      // If broad search query (e.g. 1-2 chars or unknown), give matching artist or empty
      return const ExploreSearchResult();
    }

    return ExploreSearchResult(
      songs: filteredSongs,
      artists: filteredArtists,
      albums: const [],
    );
  }
}
