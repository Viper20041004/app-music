import 'package:app_music/core/constant/app_assets.dart';
import 'package:app_music/features/main_page/explore/presentation/widget/explore_header.dart';
import 'package:app_music/features/main_page/explore/presentation/widget/explore_search_bar.dart';
import 'package:app_music/features/main_page/explore/presentation/widget/explore_section.dart';

import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080A0B),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF073C40),
                Color(0xFF071A1C),
                Color(0xFF0E0E0E),
                Color(0xFF0E0E0E),
              ],
              stops: [
                0.0,
                0.15,
                0.55,
                1.0,
              ],
            )
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28, 12, 28, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ExploreHeader(),

                const SizedBox(height: 18),

                const ExploreSearchBar(),

                const SizedBox(height: 24),

                ExploreSection(
                  title: 'Your Top Genres',
                  items: topGenres,
                ),

                const SizedBox(height: 26),

                ExploreSection(
                  title: 'Browse All',
                  items: browseItems,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static const topGenres = [
    ExploreItem(
      title: 'Kpop',
      color: Color(0xFF6FBF1E),
      image: AppAssets.genImage1,
    ),
    ExploreItem(
      title: 'Indie',
      color: Color(0xFFC21D7D),
      image: AppAssets.genImage2,
    ),
    ExploreItem(
      title: 'R&B',
      color: Color(0xFF58658E),
      image: AppAssets.genImage3,
    ),
    ExploreItem(
      title: 'Pop',
      color: Color(0xFFC75E0B),
      image: AppAssets.genImage4,
    ),
  ];

  static const browseItems = [
    ExploreItem(
      title: 'Made\nfor You',
      color: Color(0xFF2F7F9D),
      image: AppAssets.genImage5,
    ),
    ExploreItem(
      title: 'RELEASED',
      color: Color(0xFF6C287F),
      image: AppAssets.genImage6,
    ),
    ExploreItem(
      title: 'Music\nCharts',
      color: Color(0xFF263982),
      image: AppAssets.genImage7,
    ),
    ExploreItem(
      title: 'Podcasts',
      color: Color(0xFF91283A),
      image: AppAssets.genImage8,
    ),
    ExploreItem(
      title: 'Bollywood',
      color: Color(0xFF72521C),
      image: AppAssets.genImage9,
    ),
    ExploreItem(
      title: 'Pop\nFusion',
      color: Color(0xFF28594F),
      image: AppAssets.genImage5,
    ),
  ];
}

class ExploreItem {
  final String title;
  final Color color;
  final String image;

  const ExploreItem({
    required this.title,
    required this.color,
    required this.image,
  });
}