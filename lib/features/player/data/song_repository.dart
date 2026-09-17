import 'package:app_music/core/constant/app_assets.dart';
import 'package:app_music/features/main_page/library/data/song_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class SongRepository {
  final Dio _dio = Dio();

  static const List<SongModel> fallbackSongs = [
    SongModel(
      title: 'grainy days',
      artist: 'moody.',
      imagePath: AppAssets.genImage1,
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      lyrics:
          "You never look at the sky\nCause you think it's too high\nYou never look at the stars\nCause you think they're too far",
    ),
    SongModel(
      title: 'Coffee',
      artist: 'Kainbeats',
      imagePath: AppAssets.genImage2,
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      lyrics:
          "Morning coffee in my hand\nListening to the silent rain\nWalking through an empty street\nFinding peace in simple beats",
    ),
    SongModel(
      title: 'raindrops',
      artist: 'rainyyxx',
      imagePath: AppAssets.genImage3,
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      lyrics:
          "Raindrops falling on the glass\nMemories of times that pass\nSoftly playing lofi sound\nAs night falls gently all around",
    ),
    SongModel(
      title: 'Tokyo',
      artist: 'SmYang',
      imagePath: AppAssets.genImage4,
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
      lyrics:
          "Midnight lights in Tokyo\nNeon signs begin to glow\nSilent whispers in the wind\nWhere new stories will begin",
    ),
    SongModel(
      title: 'Lullaby',
      artist: 'iamfinenow',
      imagePath: AppAssets.genImage5,
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
      lyrics:
          "Close your eyes and drift away\nLeave behind the busy day\nSoftest tunes will guide your sleep\nIn a dreamland calm and deep",
    ),
    SongModel(
      title: 'Hazel Eyes',
      artist: 'moody.',
      imagePath: AppAssets.genImage6,
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-9.mp3',
      lyrics:
          "Looking into hazel eyes\nUnderneath the evening skies\nWarmest colors fill the view\nEvery moment spent with you",
    ),
  ];

  Future<List<SongModel>> fetchSongs({String query = 'lofi'}) async {
    try {
      final response = await _dio.get(
        'https://itunes.apple.com/search',
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
            final trackName = item['trackName']?.toString() ?? 'Unknown Track';
            final artistName =
                item['artistName']?.toString() ?? 'Unknown Artist';
            final previewUrl = item['previewUrl']?.toString();
            final artworkUrl = item['artworkUrl100']
                ?.toString()
                .replaceAll('100x100bb', '600x600bb');
            final fallbackAsset =
                fallbackSongs[i % fallbackSongs.length].imagePath;
            final defaultLyrics =
                fallbackSongs[i % fallbackSongs.length].lyrics;

            if (previewUrl != null && previewUrl.isNotEmpty) {
              apiSongs.add(
                SongModel(
                  title: trackName,
                  artist: artistName,
                  imagePath: fallbackAsset,
                  networkImageUrl: artworkUrl,
                  audioUrl: previewUrl,
                  lyrics: defaultLyrics,
                ),
              );
            }
          }
          if (apiSongs.isNotEmpty) {
            return apiSongs;
          }
        }
      }
    } catch (e) {
      debugPrint('SongRepository fetch error: $e');
    }

    return fallbackSongs;
  }
}
