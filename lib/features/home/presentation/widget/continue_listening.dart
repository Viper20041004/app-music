import 'package:app_music/app/theme/app_colors.dart';
import 'package:app_music/core/constant/app_assets.dart';
import 'package:flutter/material.dart';

class ContinueListening extends StatelessWidget {
  const ContinueListening({super.key});

  static const items = [
    _ContinueItem(
      title: 'Coffee & Jazz',
      image: AppAssets.coffeeJazzImage,
    ),
    _ContinueItem(
      title: 'Top New Songs',
      image: AppAssets.releasedImage,
    ),
    _ContinueItem(
      title: 'Anything Goes',
      image: AppAssets.anythingGoesImage,
    ),
    _ContinueItem(
      title: 'Anime OSTs',
      image: AppAssets.animeSongImage,
    ),
    _ContinueItem(
      title: "Harry's House",
      image: AppAssets.harryHouseImage,
    ),
    _ContinueItem(
      title: 'Lo-Fi Beats',
      image: AppAssets.lofiBeatImage,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 9,
        childAspectRatio: 2.75,
      ),
      itemBuilder: (context, index) {
        final item = items[index];

        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  item.image,
                  fit: BoxFit.cover,
                  alignment: Alignment.centerLeft,
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(width: 5),
            ],
          ),
        );
      },
    );
  }
}

class _ContinueItem {
  final String title;
  final String image;

  const _ContinueItem({
    required this.title,
    required this.image,
  });
}