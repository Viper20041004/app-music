
class MixItem {
  final String title;
  final String subtitle;
  final String image;
  final String? searchQuery;

  MixItem({
    required this.title,
    required this.subtitle,
    required this.image,
    this.searchQuery,
  });
}