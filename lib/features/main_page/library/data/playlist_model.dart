class PlaylistModel {
  final int? id;
  final String title;
  final String songCount;
  final String imagePath;
  final String? description;
  final String? fromCategory;
  final String? createdAt;

  const PlaylistModel({
    this.id,
    required this.title,
    required this.songCount,
    required this.imagePath,
    this.description,
    this.fromCategory,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'image_path': imagePath,
      'song_count': int.tryParse(songCount) ?? 0,
      'created_at': createdAt ?? DateTime.now().toIso8601String(),
    };
  }

  factory PlaylistModel.fromMap(Map<String, dynamic> map) {
    final countInt = map['song_count'] as int? ?? 0;
    return PlaylistModel(
      id: map['id'] as int?,
      title: map['title'] as String? ?? 'Untitled Playlist',
      songCount: '$countInt songs',
      imagePath: map['image_path'] as String? ?? '',
      description: map['description'] as String?,
      createdAt: map['created_at'] as String?,
    );
  }

  PlaylistModel copyWith({
    int? id,
    String? title,
    String? songCount,
    String? imagePath,
    String? description,
    String? fromCategory,
    String? createdAt,
  }) {
    return PlaylistModel(
      id: id ?? this.id,
      title: title ?? this.title,
      songCount: songCount ?? this.songCount,
      imagePath: imagePath ?? this.imagePath,
      description: description ?? this.description,
      fromCategory: fromCategory ?? this.fromCategory,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
