class PlaylistModel {
  final String title;
  final String songCount;
  final String imagePath;
  final String? description;
  final String? fromCategory;

  const PlaylistModel({
    required this.title,
    required this.songCount,
    required this.imagePath,
    this.description,
    this.fromCategory,
  });
}
