import 'package:app_music/core/network/api_constants.dart';
import 'package:app_music/features/main_page/library/data/song_model.dart';

enum ExploreSearchFilter {
  all('All'),
  song('Song'),
  artist('Artist'),
  album('Album');

  final String label;
  const ExploreSearchFilter(this.label);
}

class ExploreArtist {
  final int? id;
  final String name;
  final String? imageUrl;
  final String? description;

  const ExploreArtist({
    this.id,
    required this.name,
    this.imageUrl,
    this.description,
  });

  factory ExploreArtist.fromJson(Map<String, dynamic> json, {String? baseUrl}) {
    final base = baseUrl ?? ApiConstants.defaultBaseUrl;
    String? img = json['imageUrl']?.toString() ?? json['image_url']?.toString();
    if (img != null && img.isNotEmpty) {
      if (!img.startsWith('http://') && !img.startsWith('https://') && !img.startsWith('assets/')) {
        if (!img.startsWith('/')) {
          img = '/$img';
        }
        img = '$base$img';
      }
    }

    return ExploreArtist(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      name: json['name']?.toString() ?? 'Unknown Artist',
      imageUrl: img,
      description: json['description']?.toString(),
    );
  }
}

class ExploreAlbum {
  final int? id;
  final String title;
  final String? imageUrl;
  final String? releaseDate;
  final int? artistId;

  const ExploreAlbum({
    this.id,
    required this.title,
    this.imageUrl,
    this.releaseDate,
    this.artistId,
  });

  factory ExploreAlbum.fromJson(Map<String, dynamic> json, {String? baseUrl}) {
    final base = baseUrl ?? ApiConstants.defaultBaseUrl;
    String? img = json['imageUrl']?.toString() ?? json['image_url']?.toString();
    if (img != null && img.isNotEmpty) {
      if (!img.startsWith('http://') && !img.startsWith('https://') && !img.startsWith('assets/')) {
        if (!img.startsWith('/')) {
          img = '/$img';
        }
        img = '$base$img';
      }
    }

    return ExploreAlbum(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      title: json['title']?.toString() ?? json['name']?.toString() ?? 'Unknown Album',
      imageUrl: img,
      releaseDate: json['releaseDate']?.toString() ?? json['release_date']?.toString(),
      artistId: json['artistId'] is int ? json['artistId'] as int : int.tryParse(json['artistId']?.toString() ?? ''),
    );
  }
}

class ExploreSearchResult {
  final List<SongModel> songs;
  final List<ExploreArtist> artists;
  final List<ExploreAlbum> albums;

  const ExploreSearchResult({
    this.songs = const [],
    this.artists = const [],
    this.albums = const [],
  });

  int get totalCount => songs.length + artists.length + albums.length;

  bool get isEmpty => songs.isEmpty && artists.isEmpty && albums.isEmpty;
  bool get isNotEmpty => !isEmpty;
}
