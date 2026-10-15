import 'dart:async';

import 'package:app_music/app/theme/app_colors.dart';
import 'package:app_music/core/constant/app_assets.dart';
import 'package:app_music/core/navigation/app_navigator.dart';
import 'package:app_music/features/main_page/explore/presentation/page/artist_detail_screen.dart';
import 'package:app_music/features/main_page/library/data/library_search_item.dart';
import 'package:app_music/features/main_page/library/data/song_model.dart';
import 'package:app_music/features/main_page/library/presentation/widget/search_bar_widget.dart';
import 'package:app_music/features/main_page/library/presentation/widget/search_recently.dart';
import 'package:app_music/features/player/data/song_repository.dart';
import 'package:app_music/features/player/presentation/page/now_playing_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class LibrarySearchScreen extends StatefulWidget {
  const LibrarySearchScreen({super.key});

  @override
  State<LibrarySearchScreen> createState() => _LibrarySearchScreenState();
}

class _LibrarySearchScreenState extends State<LibrarySearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final SongRepository _songRepository = SongRepository();

  Timer? _debounceTimer;
  bool _isLoading = false;
  List<SongModel> _apiSongs = [];

  final List<LibrarySearchItem> _recentlyPlayed = [
    LibrarySearchItem(
      title: 'Conan Gray',
      subtitle: '',
      image: AppAssets.artistImage1,
    ),
    LibrarySearchItem(
      title: 'DAWN FM',
      subtitle: 'The Weeknd',
      image: AppAssets.musicImage1,
    ),
    LibrarySearchItem(
      title: 'Water Fountain',
      subtitle: 'alec benjamin',
      image: AppAssets.musicImage2,
    ),
    LibrarySearchItem(
      title: 'Wiped Out!',
      subtitle: 'The Neighbourhood',
      image: AppAssets.musicImage3,
    ),
    LibrarySearchItem(
      title: 'Baking a Mystery',
      subtitle: 'Updated Aug 21 • Stephanie Soo',
      image: AppAssets.musicImage4,
    ),
    LibrarySearchItem(
      title: 'keshi',
      subtitle: '',
      image: AppAssets.artistImage4,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    _debounceTimer?.cancel();

    if (query.isEmpty) {
      setState(() {
        _isLoading = false;
        _apiSongs = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _debounceTimer = Timer(const Duration(milliseconds: 400), () async {
      try {
        final songs = await _songRepository.searchSongs(query);
        if (!mounted) return;
        setState(() {
          _apiSongs = songs;
          _isLoading = false;
        });
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim();
    final isSearching = query.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Search',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SearchBarWidget(
                controller: _searchController,
              ),
            ),

            const SizedBox(height: 25),

            // Body
            Expanded(
              child: isSearching ? _buildSearchResults(query) : _buildRecentlyPlayed(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(String query) {
    if (_isLoading && _apiSongs.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: Color(0xFF00AFC4),
              strokeWidth: 2.5,
            ),
            SizedBox(height: 14),
            Text(
              'Searching songs...',
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ],
        ),
      );
    }

    if (_apiSongs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.search_off_rounded,
                size: 48,
                color: Colors.white38,
              ),
              const SizedBox(height: 12),
              Text(
                'No results found for "$query"',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 30,
      ),
      itemCount: _apiSongs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final song = _apiSongs[index];
        return GestureDetector(
          onTap: () {
            AppNavigator.push(
              context,
              NowPlayingScreen(
                song: song,
                playlistName: 'Search Results',
              ),
            );
          },
          behavior: HitTestBehavior.opaque,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: song.networkImageUrl != null && song.networkImageUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: song.networkImageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.white10,
                            child: const Center(
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF00AFC4),
                                ),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            song.imagePath,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          song.imagePath,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      song.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.play_circle_outline,
                color: Color(0xFF00AFC4),
                size: 26,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecentlyPlayed() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 5),
              Text(
                '⇅ Recently played',
                style: TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ..._recentlyPlayed.map(
            (item) => SearchRecentlyItem(
              item: item,
              onTap: () {
                if (item.subtitle.isEmpty ||
                    item.title.toLowerCase().contains('conan') ||
                    item.title.toLowerCase().contains('keshi') ||
                    item.title.toLowerCase().contains('sơn tùng')) {
                  AppNavigator.push(
                    context,
                    ArtistDetailScreen(
                      name: item.title,
                      avatarUrl: item.image,
                      bannerUrl: item.title.toLowerCase().contains('sơn tùng')
                          ? AppAssets.sontungBanner
                          : null,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}