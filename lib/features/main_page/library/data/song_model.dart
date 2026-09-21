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
