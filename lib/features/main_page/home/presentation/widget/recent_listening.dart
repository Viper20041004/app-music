import 'dart:math';

import 'package:app_music/core/constant/app_assets.dart';
import 'package:flutter/material.dart';

class RecentListening extends StatefulWidget {
  const RecentListening({super.key});

  @override
  State<RecentListening> createState() => _RecentListeningState();
}

class _RecentListeningState extends State<RecentListening> {
  static const images = [
    AppAssets.musicImage3,
    AppAssets.musicImage4,
    AppAssets.musicImage5,
    AppAssets.musicImage6,
    AppAssets.musicImage7,
    AppAssets.musicImage8,
  ];

  late final List<String> randomImages;

  @override
  void initState() {
    super.initState();

    final shuffled = [...images]..shuffle(Random());

    randomImages = shuffled.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 205,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: randomImages.length,
        separatorBuilder: (_, __) {
          return const SizedBox(width: 20);
        },
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Image.asset(
              randomImages[index],
              width: 180,
              height: 205,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}