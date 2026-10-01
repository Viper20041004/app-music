import 'dart:async';
import 'package:app_music/app/theme/app_colors.dart';
import 'package:app_music/core/constant/app_assets.dart';
import 'package:app_music/core/navigation/app_navigator.dart';
import 'package:app_music/features/main_page/library/data/playlist_model.dart';
import 'package:app_music/features/main_page/library/presentation/page/playlist_detail_screen.dart';
import 'package:flutter/material.dart';

class ContinueListening extends StatefulWidget {
  const ContinueListening({super.key});

  @override
  State<ContinueListening> createState() => _ContinueListeningState();
}

class _ContinueListeningState extends State<ContinueListening> {
  static const items = [
    _BannerItem(
      title: 'Coffee & Jazz',
      subtitle: 'Smooth jazz & acoustic chill tunes',
      tag: 'FEATURED',
      image: AppAssets.banner1,
      accentColor: Color(0xFFE5A93B),
    ),
    _BannerItem(
      title: 'Top New Songs',
      subtitle: 'Trending worldwide hits this week',
      tag: 'HOT RELEASE',
      image: AppAssets.banner2,
      accentColor: Color(0xFFFF5252),
    ),
    _BannerItem(
      title: 'Anything Goes',
      subtitle: 'Eclectic vibes for every mood',
      tag: 'RECOMMENDED',
      image: AppAssets.banner3,
      accentColor: Color(0xFF8B5CF6),
    ),
    _BannerItem(
      title: 'Anime OSTs',
      subtitle: 'Iconic soundtracks & emotional themes',
      tag: 'POPULAR',
      image: AppAssets.banner4,
      accentColor: Color(0xFF00E5FF),
    ),
    _BannerItem(
      title: "Harry's House",
      subtitle: 'Award-winning album & pop tracks',
      tag: 'SPECIAL',
      image: AppAssets.banner5,
      accentColor: Color(0xFFFF7043),
    ),
    _BannerItem(
      title: 'Lo-Fi Beats',
      subtitle: 'Chill beats to study, relax & unwind',
      tag: 'LO-FI VIBES',
      image: AppAssets.lofiBeatImage,
      accentColor: Color(0xFF69F0AE),
    ),
  ];

  static const int _virtualInitialPage = 1200;
  late final PageController _pageController;
  late int _currentPage;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentPage = _virtualInitialPage;
    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: 1.0,
    );
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _stopAutoPlay();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _stopAutoPlay() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stopAutoPlay();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeIndex = _currentPage % items.length;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollStartNotification) {
          if (notification.dragDetails != null) {
            _stopAutoPlay();
          }
        } else if (notification is ScrollEndNotification) {
          _startAutoPlay();
        }
        return false;
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 165,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final item = items[index % items.length];

                return GestureDetector(
                  onTap: () {
                    AppNavigator.push(
                      context,
                      PlaylistDetailScreen(
                        playlist: PlaylistModel(
                          title: item.title,
                          songCount: '20 songs',
                          imagePath: item.image,
                          fromCategory: 'CONTINUE LISTENING',
                          description: item.subtitle,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Background Image
                          Image.asset(
                            item.image,
                            fit: BoxFit.cover,
                          ),

                          // Gradient Overlay for readability
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Colors.black.withValues(alpha: 0.15),
                                  Colors.black.withValues(alpha: 0.65),
                                  Colors.black.withValues(alpha: 0.92),
                                ],
                                stops: const [0.0, 0.45, 1.0],
                              ),
                            ),
                          ),

                          // Accent glow
                          Positioned(
                            top: -30,
                            left: -30,
                            child: Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    item.accentColor.withValues(alpha: 0.35),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Content overlay
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: item.accentColor.withValues(alpha: 0.85),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: item.accentColor.withValues(alpha: 0.3),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.graphic_eq_rounded,
                                        color: Colors.white,
                                        size: 13,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        item.tag,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const Spacer(),

                                // Bottom Row: Titles + Play Button
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            item.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                              letterSpacing: -0.3,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            item.subtitle,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white
                                                  .withValues(alpha: 0.8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.primary,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primary
                                                .withValues(alpha: 0.5),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.play_arrow_rounded,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Dots Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(items.length, (i) {
              final isSelected = i == activeIndex;
              return GestureDetector(
                onTap: () {
                  final targetPage = _currentPage + (i - activeIndex);
                  _pageController.animateToPage(
                    targetPage,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOutCubic,
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  height: 5,
                  width: isSelected ? 20 : 6,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _BannerItem {
  final String title;
  final String subtitle;
  final String tag;
  final String image;
  final Color accentColor;

  const _BannerItem({
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.image,
    required this.accentColor,
  });
}