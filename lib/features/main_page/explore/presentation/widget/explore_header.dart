import 'package:app_music/core/constant/app_assets.dart';
import 'package:flutter/material.dart';

class ExploreHeader extends StatelessWidget {
  const ExploreHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(AppAssets.logoImage, width: 40),
        const SizedBox(width: 10),
        const Text(
          'Search',
          style: TextStyle(
            color: Color(0xFF59CBD3),
            fontSize: 25,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}