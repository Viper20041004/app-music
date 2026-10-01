import 'package:app_music/core/constant/app_assets.dart';
import 'package:app_music/core/network/api_constants.dart';

class SongModel {
  final int? id;
  final String? serverId;
  final String title;
  final String artist;
  final String? album;
  final String imagePath;
  final String? networkImageUrl;
  final String? audioUrl;
  final String? lyrics;
  final int? duration;
  final bool isFavorite;
  final String? createdAt;

  const SongModel({
    this.id,
    this.serverId,
    required this.title,
    required this.artist,
    this.album,
    required this.imagePath,
    this.networkImageUrl,
    this.audioUrl,
    this.lyrics,
    this.duration,
    this.isFavorite = false,
    this.createdAt,
  });

  factory SongModel.fromJson(Map<String, dynamic> json, {String? baseUrl}) {
    final base = baseUrl ?? ApiConstants.defaultBaseUrl;

    // Parse artist name: could be Map or String
    String artistName = 'Unknown Artist';
    if (json['artist'] is Map) {
      artistName = json['artist']['name']?.toString() ?? 'Unknown Artist';
    } else if (json['artist'] is String) {
      artistName = json['artist'] as String;
    }

    // Parse album name
    String? albumName;
    if (json['album'] is Map) {
      albumName = json['album']['title']?.toString() ?? json['album']['name']?.toString();
    } else if (json['album'] is String) {
      albumName = json['album'] as String;
    }

    // Parse audioUrl: format may be /uploads/... or http://...
    String? audio = json['audioUrl']?.toString() ?? json['audio_url']?.toString();
    if (audio != null && audio.isNotEmpty) {
      if (!audio.startsWith('http://') && !audio.startsWith('https://') && !audio.startsWith('assets/')) {
        if (!audio.startsWith('/')) {
          audio = '/$audio';
        }
        audio = '$base$audio';
      }
    }

    // Parse imageUrl: format may be /uploads/... or http://...
    String? netImg = json['imageUrl']?.toString() ?? json['network_image_url']?.toString();
    if (netImg != null && netImg.isNotEmpty) {
      if (!netImg.startsWith('http://') && !netImg.startsWith('https://') && !netImg.startsWith('assets/')) {
        if (!netImg.startsWith('/')) {
          netImg = '/$netImg';
        }
        netImg = '$base$netImg';
      }
    }

    return SongModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      serverId: json['serverId']?.toString() ?? json['server_id']?.toString() ?? json['id']?.toString(),
      title: json['title']?.toString() ?? 'Unknown Title',
      artist: artistName,
      album: albumName,
      imagePath: json['imagePath']?.toString() ?? json['image_path']?.toString() ?? AppAssets.genImage1,
      networkImageUrl: netImg,
      audioUrl: audio,
      lyrics: json['lyric']?.toString() ?? json['lyrics']?.toString(),
      duration: json['duration'] is int ? json['duration'] as int : int.tryParse(json['duration']?.toString() ?? ''),
      isFavorite: json['is_favorite'] == 1 || json['is_favorite'] == true || json['isFavorite'] == true,
      createdAt: json['createdAt']?.toString() ?? json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'server_id': serverId,
      'title': title,
      'artist': artist,
      'album': album,
      'image_path': imagePath,
      'network_image_url': networkImageUrl,
      'audio_url': audioUrl,
      'lyrics': lyrics,
      'duration': duration,
      'is_favorite': isFavorite ? 1 : 0,
      'created_at': createdAt ?? DateTime.now().toIso8601String(),
    };
  }

  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      id: map['id'] as int?,
      serverId: map['server_id'] as String?,
      title: map['title'] as String? ?? 'Unknown Title',
      artist: map['artist'] as String? ?? 'Unknown Artist',
      album: map['album'] as String?,
      imagePath: map['image_path'] as String? ?? '',
      networkImageUrl: map['network_image_url'] as String?,
      audioUrl: map['audio_url'] as String?,
      lyrics: map['lyrics'] as String?,
      duration: map['duration'] as int?,
      isFavorite: (map['is_favorite'] as int? ?? 0) == 1,
      createdAt: map['created_at'] as String?,
    );
  }

  SongModel copyWith({
    int? id,
    String? serverId,
    String? title,
    String? artist,
    String? album,
    String? imagePath,
    String? networkImageUrl,
    String? audioUrl,
    String? lyrics,
    int? duration,
    bool? isFavorite,
    String? createdAt,
  }) {
    return SongModel(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      imagePath: imagePath ?? this.imagePath,
      networkImageUrl: networkImageUrl ?? this.networkImageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      lyrics: lyrics ?? this.lyrics,
      duration: duration ?? this.duration,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
