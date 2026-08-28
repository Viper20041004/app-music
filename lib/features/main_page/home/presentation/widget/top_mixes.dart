import 'dart:math';

import 'package:app_music/app/theme/app_colors.dart';
import 'package:app_music/core/constant/app_assets.dart';
import 'package:flutter/material.dart';

class TopMixes extends StatelessWidget {
  const TopMixes({super.key});

  static const mixes = [
    _MixItem(
      title: 'US UK',
      image: AppAssets.usUkImage,
      progress: 0.75,
    ),
    _MixItem(
      title: 'KPOP',
      image: AppAssets.kpopImage,
      progress: 0.55,
    ),
    _MixItem(
      title: 'Lofi chill',
      image: AppAssets.lofiImage,
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
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: Image.asset(
                            mix.image,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 8,
                        top: 8,
                        child: Text(
                          mix.title,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                        )
                      ),
                    ]
                  )
                ),
                ClipRRect(
                  child: LinearProgressIndicator(
                    value: 1,
                    minHeight: 8,
                    backgroundColor: Colors.white12,
                    valueColor: AlwaysStoppedAnimation(
                      randomColor()
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

  Color randomColor() {
    final random = Random();

    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
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