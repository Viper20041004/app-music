class SongModel {
  final String title;
  final String artist;
  final String imagePath;
  final String? networkImageUrl;
  final String? audioUrl;
  final String? lyrics;

  const SongModel({
    required this.title,
    required this.artist,
    required this.imagePath,
    this.networkImageUrl,
    this.audioUrl,
    this.lyrics,
  });
}
