import 'package:app_music/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TopMixes extends StatelessWidget {
  const TopMixes({super.key});

  static const mixes = [
    _MixItem(
      title: 'Pop Mix',
      image: 'https://picsum.photos/400/500?10',
      progress: 0.75,
    ),
    _MixItem(
      title: 'Chill Mix',
      image: 'https://picsum.photos/400/500?11',
      progress: 0.55,
    ),
    _MixItem(
      title: 'Night Mix',
      image: 'https://picsum.photos/400/500?12',
      progress: 0.4,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 155,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: mixes.length,
        separatorBuilder: (_, __) {
          return const SizedBox(width: 14);
        },
        itemBuilder: (context, index) {
          final mix = mixes[index];

          return SizedBox(
            width: 105,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Image.network(
                      mix.image,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  mix.title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 5),

                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(
                    value: mix.progress,
                    minHeight: 4,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation(
                      AppColors.pink,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MixItem {
  final String title;
  final String image;
  final double progress;

  const _MixItem({
    required this.title,
    required this.image,
    required this.progress,
  });
}