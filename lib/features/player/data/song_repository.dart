import 'package:app_music/core/constant/app_assets.dart';
import 'package:app_music/core/database/database_helper.dart';
import 'package:app_music/features/main_page/library/data/song_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class SongRepository {
  final Dio _dio = Dio();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  static const List<SongModel> fallbackSongs = [
    SongModel(
      id: 1,
      title: 'grainy days',
      artist: 'moody.',
      album: 'Lofi Chill',
      imagePath: AppAssets.genImage1,
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      lyrics:
          "You never look at the sky\nCause you think it's too high\nYou never look at the stars\nCause you think they're too far",
      duration: 210,
    ),
    SongModel(
      id: 2,
      title: 'Coffee',
      artist: 'Kainbeats',
      album: 'Morning Coffee',
      imagePath: AppAssets.genImage2,
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      lyrics:
          "Morning coffee in my hand\nListening to the silent rain\nWalking through an empty street\nFinding peace in simple beats",
      duration: 180,
    ),
    SongModel(
      id: 3,
      title: 'raindrops',
      artist: 'rainyyxx',
      album: 'Rainy Nights',
      imagePath: AppAssets.genImage3,
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      lyrics:
          "Raindrops falling on the glass\nMemories of times that pass\nSoftly playing lofi sound\nAs night falls gently all around",
      duration: 240,
    ),
    SongModel(
      id: 4,
      title: 'Tokyo',
      artist: 'SmYang',
      album: 'City Lights',
      imagePath: AppAssets.genImage4,
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
      lyrics:
          "Midnight lights in Tokyo\nNeon signs begin to glow\nSilent whispers in the wind\nWhere new stories will begin",
      duration: 205,
    ),
    SongModel(
      id: 5,
      title: 'Lullaby',
      artist: 'iamfinenow',
      album: 'Sleep & Relax',
      imagePath: AppAssets.genImage5,
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
      lyrics:
          "Close your eyes and drift away\nLeave behind the busy day\nSoftest tunes will guide your sleep\nIn a dreamland calm and deep",
      duration: 195,
    ),
    SongModel(
      id: 6,
      title: 'Hazel Eyes',
      artist: 'moody.',
      album: 'Lofi Chill',
      imagePath: AppAssets.genImage6,
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-9.mp3',
      lyrics:
          "Looking into hazel eyes\nUnderneath the evening skies\nWarmest colors fill the view\nEvery moment spent with you",
      duration: 225,
    ),
  ];

  Future<List<SongModel>> fetchSongs({String query = 'lofi', int quantity = 6, }) async {
    try {
      final response = await _dio.get(
        'https://api.jamendo.com/v3.0/tracks/',
        queryParameters: {
          'term': query,
          'entity': 'song',
          'limit': 6,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> data =
            response.data is Map<String, dynamic> ? response.data : {};
        final results = data['results'] as List<dynamic>?;
        if (results != null && results.isNotEmpty) {
          final List<SongModel> apiSongs = [];
          for (int i = 0; i < results.length; i++) {
            final item = results[i];
            final trackId = item['trackId']?.toString();
            final trackName = item['trackName']?.toString() ?? 'Unknown Track';
            final artistName =
                item['artistName']?.toString() ?? 'Unknown Artist';
            final collectionName = item['collectionName']?.toString();
            final previewUrl = item['previewUrl']?.toString();
            final artworkUrl = item['artworkUrl100']
                ?.toString()
                .replaceAll('100x100bb', '600x600bb');
            final trackTimeMillis = item['trackTimeMillis'] as int?;
            final durationSec = trackTimeMillis != null ? trackTimeMillis ~/ 1000 : null;

            final fallbackAsset =
                fallbackSongs[i % fallbackSongs.length].imagePath;
            final defaultLyrics =
                fallbackSongs[i % fallbackSongs.length].lyrics;

            if (previewUrl != null && previewUrl.isNotEmpty) {
              final song = SongModel(
                serverId: trackId,
                title: trackName,
                artist: artistName,
                album: collectionName,
                imagePath: fallbackAsset,
                networkImageUrl: artworkUrl,
                audioUrl: previewUrl,
                lyrics: defaultLyrics,
                duration: durationSec,
              );
              apiSongs.add(song);
            }
          }
          if (apiSongs.isNotEmpty) {
            // Save fetched songs to SQLite
            await _dbHelper.insertSongs(apiSongs);
            return apiSongs;
          }
        }
      }
    } catch (e) {
      debugPrint('SongRepository fetch error: $e');
    }

    // Try fetching from local SQLite DB first
    try {
      final dbSongs = await _dbHelper.getAllSongs();
      if (dbSongs.isNotEmpty) {
        return dbSongs;
      }

      // Seed fallback songs to DB if empty
      await _dbHelper.insertSongs(fallbackSongs);
      return fallbackSongs;
    } catch (e) {
      debugPrint('SQLite fetch error: $e');
    }

    return fallbackSongs;
  }
}
