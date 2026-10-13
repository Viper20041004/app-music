import 'package:app_music/core/navigation/app_navigator.dart';
import 'package:app_music/features/main_page/explore/data/topic_model.dart';
import 'package:app_music/features/main_page/library/data/playlist_model.dart';
import 'package:app_music/features/main_page/library/presentation/page/playlist_detail_screen.dart';
import 'package:flutter/material.dart';

class TopicPlaylistCard extends StatelessWidget {
  final TopicPlaylist playlist;
  final String sectionTitle;

  const TopicPlaylistCard({
    super.key,
    required this.playlist,
    required this.sectionTitle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppNavigator.push(
          context,
          PlaylistDetailScreen(
            playlist: PlaylistModel(
              title: playlist.title,
              songCount: playlist.songCount ?? '20 songs',
              imagePath: playlist.image,
              fromCategory: sectionTitle.toUpperCase(),
              description: playlist.description ??
                  playlist.subtitle ??
                  'Tuyển tập các ca khúc ${playlist.title} được yêu thích nhất',
              searchQuery: playlist.searchQuery ?? playlist.title,
            ),
          ),
        );
      },
      child: SizedBox(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Artwork image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  playlist.image,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF1F2B28),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.music_note,
                        color: Colors.white54,
                        size: 36,
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Playlist Title
            Text(
              playlist.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.1,
              ),
            ),

            const SizedBox(height: 3),

            // Subtitle / Artists
            if (playlist.subtitle != null && playlist.subtitle!.isNotEmpty)
              Text(
                playlist.subtitle!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFA7A7A7),
                  height: 1.25,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
