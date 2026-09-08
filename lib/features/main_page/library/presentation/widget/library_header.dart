import 'package:app_music/app/theme/app_colors.dart';
import 'package:app_music/core/constant/app_assets.dart';
import 'package:app_music/core/navigation/app_navigator.dart';
import 'package:app_music/features/main_page/library/presentation/page/library_search_screen.dart';
import 'package:flutter/material.dart';

class LibraryHeader extends StatelessWidget {
  const LibraryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppAssets.logoImage),
              fit: BoxFit.cover,
            ),
          ),
        ),

        const SizedBox(width: 8),

        Text(
          'Your Library',
          style: TextStyle(
            color: AppColors.primaryDark,
            fontSize: 25,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),

        const Spacer(),

        IconButton(
          onPressed: () {
            AppNavigator.push(
              context,
              const LibrarySearchScreen(),
            );
          },
          icon: const Icon(
            Icons.search,
            color: Colors.white,
            size: 30,
          ),
        ),
      ],
    );
  }
}