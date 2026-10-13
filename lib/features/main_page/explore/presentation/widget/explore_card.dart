
import 'package:app_music/core/navigation/app_navigator.dart';
import 'package:app_music/features/main_page/explore/presentation/page/explore_screen.dart';
import 'package:app_music/features/main_page/explore/presentation/page/topic_detail_screen.dart';
import 'package:flutter/material.dart';

class ExploreCard extends StatelessWidget {
  final ExploreItem item;
  final String? category;
  final VoidCallback? onTap;

  const ExploreCard({
    super.key,
    required this.item,
    this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background banner image
          Image.asset(
            item.image,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: item.color ?? const Color(0xFF232533),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.music_note,
                  color: Colors.white38,
                  size: 28,
                ),
              );
            },
          ),

          // Title
          Positioned(
            top: 14,
            left: 14,
            right: 48,
            child: Text(
              item.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Tap feedback & navigation to song list
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: onTap ??
                    item.onTap ??
                    () {
                      AppNavigator.push(
                        context,
                        TopicDetailScreen(
                          topic: item,
                        ),
                      );
                    },
              ),
            ),
          ),
        ],
      ),
    );
  }
}