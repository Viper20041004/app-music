import 'package:app_music/features/main_page/library/data/song_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

void showSongOptionsMenu(BuildContext context, SongModel song) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => SongOptionsBottomSheet(song: song),
  );
}

class SongOptionsBottomSheet extends StatefulWidget {
  final SongModel song;

  const SongOptionsBottomSheet({
    super.key,
    required this.song,
  });

  @override
  State<SongOptionsBottomSheet> createState() => _SongOptionsBottomSheetState();
}

class _SongOptionsBottomSheetState extends State<SongOptionsBottomSheet> {
  bool isLiked = true;

  Widget _buildArtwork() {
    final netUrl = widget.song.networkImageUrl;
    const imageSize = 180.0;

    if (netUrl != null && netUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: netUrl,
        width: imageSize,
        height: imageSize,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: imageSize,
          height: imageSize,
          color: Colors.white10,
          child: const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF00AFC4),
              strokeWidth: 2,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Image.asset(
          widget.song.imagePath,
          width: imageSize,
          height: imageSize,
          fit: BoxFit.cover,
        ),
      );
    }

    return Image.asset(
      widget.song.imagePath,
      width: imageSize,
      height: imageSize,
      fit: BoxFit.cover,
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Color(0xFF0F1113),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked
                          ? const Color(0xFF00AFC4)
                          : Colors.white70,
                      size: 26,
                    ),
                    onPressed: () {
                      setState(() {
                        isLiked = !isLiked;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      debugPrint('Add clicked');
                    },
                  ),
                ],
              ),
            ),

            // Scrollable Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 8),

                    // Song Artwork
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: _buildArtwork(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Song Title & Artist
                    Text(
                      widget.song.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      widget.song.artist,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Options List
                    _buildMenuItem(
                      icon: Icons.music_note,
                      title: 'Add to playlist',
                      onTap: () => debugPrint('Add to playlist'),
                    ),
                    _buildMenuItem(
                      icon: Icons.queue_music,
                      title: 'Add to queue',
                      onTap: () => debugPrint('Add to queue'),
                    ),
                    _buildMenuItem(
                      icon: Icons.remove_circle_outline,
                      title: 'Remove from playlist',
                      onTap: () => debugPrint('Remove from playlist'),
                    ),
                    _buildMenuItem(
                      icon: Icons.sell_outlined,
                      title: 'Modify tags',
                      onTap: () => debugPrint('Modify tags'),
                    ),
                    _buildMenuItem(
                      icon: Icons.person_outline,
                      title: 'View Artist',
                      onTap: () => debugPrint('View Artist'),
                    ),
                    _buildMenuItem(
                      icon: Icons.disc_full_outlined,
                      title: 'View Album',
                      onTap: () => debugPrint('View Album'),
                    ),
                    _buildMenuItem(
                      icon: Icons.subtitles_outlined,
                      title: 'Show Credits',
                      onTap: () => debugPrint('Show Credits'),
                    ),
                    _buildMenuItem(
                      icon: Icons.download_outlined,
                      title: 'Download',
                      onTap: () => debugPrint('Download'),
                    ),
                    _buildMenuItem(
                      icon: Icons.share_outlined,
                      title: 'Share',
                      onTap: () => debugPrint('Share'),
                    ),
                    _buildMenuItem(
                      icon: Icons.qr_code_2,
                      title: 'Generate QR Code',
                      onTap: () => debugPrint('Generate QR Code'),
                    ),
                    _buildMenuItem(
                      icon: Icons.nightlight_outlined,
                      title: 'Sleep Timer',
                      onTap: () => debugPrint('Sleep Timer'),
                    ),
                    _buildMenuItem(
                      icon: Icons.do_not_disturb_on_outlined,
                      title: 'Hide song',
                      onTap: () => debugPrint('Hide song'),
                    ),
                    _buildMenuItem(
                      icon: Icons.cell_tower,
                      title: 'Go to Song Radio',
                      onTap: () => debugPrint('Go to Song Radio'),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
