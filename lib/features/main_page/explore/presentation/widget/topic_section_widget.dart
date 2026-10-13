import 'package:app_music/features/main_page/explore/data/topic_model.dart';
import 'package:app_music/features/main_page/explore/presentation/widget/topic_playlist_card.dart';
import 'package:flutter/material.dart';

class TopicSectionWidget extends StatelessWidget {
  final TopicSection section;

  const TopicSectionWidget({
    super.key,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header (design identical to screenshot e.g. "Pop Ballad")
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            section.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
        ),

        const SizedBox(height: 14),

        // Horizontal scrolling playlists
        SizedBox(
          height: 225,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: section.playlists.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final playlist = section.playlists[index];
              return TopicPlaylistCard(
                playlist: playlist,
                sectionTitle: section.title,
              );
            },
          ),
        ),
      ],
    );
  }
}
