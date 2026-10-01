import 'package:app_music/core/navigation/app_navigator.dart';
import 'package:app_music/features/main_page/library/data/playlist_model.dart';
import 'package:app_music/features/main_page/home/data/mix_item.dart';
import 'package:app_music/features/main_page/library/presentation/page/playlist_detail_screen.dart';
import 'package:flutter/material.dart';

class TopMixes extends StatelessWidget {
  final List<MixItem> mixes;
  const TopMixes({super.key, required this.mixes});


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 215,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: mixes.length,
        separatorBuilder: (_, _) {
          return const SizedBox(width: 14);
        },
        itemBuilder: (context, index) {
          final mix = mixes[index];

          return GestureDetector(
            onTap: () {
              AppNavigator.push(
                context,
                PlaylistDetailScreen(
                  playlist: PlaylistModel(
                    title: mix.title,
                    songCount: '50 songs',
                    imagePath: mix.image,
                    fromCategory: 'ALL ABOUT VIET MUSIC',
                    description: mix.subtitle,
                    searchQuery: mix.searchQuery ?? mix.title,
                  ),
                ),
              );
            },
            child: SizedBox(
              width: 145,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(
                        mix.image,
                        width: 145,
                        height: 145,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    mix.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    mix.subtitle,
                    maxLines: 2,
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
        },
      ),
    );
  }
}
