class TopicPlaylist {
  final String title;
  final String image;
  final String? subtitle;
  final String? songCount;
  final String? description;
  final String? searchQuery;

  const TopicPlaylist({
    required this.title,
    required this.image,
    this.subtitle,
    this.songCount = '20 songs',
    this.description,
    this.searchQuery,
  });
}

class TopicSection {
  final String title;
  final List<TopicPlaylist> playlists;

  const TopicSection({
    required this.title,
    required this.playlists,
  });
}
