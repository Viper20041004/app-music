import 'package:app_music/app/theme/app_colors.dart';
import 'package:app_music/core/constant/app_assets.dart';
import 'package:app_music/features/main_page/library/data/library_search_item.dart';
import 'package:app_music/features/main_page/library/presentation/widget/search_bar_widget.dart';
import 'package:app_music/features/main_page/library/presentation/widget/search_recently.dart';
import 'package:flutter/material.dart';

class LibrarySearchScreen extends StatefulWidget {
  const LibrarySearchScreen({super.key});

  @override
  State<LibrarySearchScreen> createState() => _LibrarySearchScreenState();
}

class _LibrarySearchScreenState extends State<LibrarySearchScreen> {
  final TextEditingController _searchController = TextEditingController();

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

  List<LibrarySearchItem> get filteredItems {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return _recentlyPlayed;
    }

    return _recentlyPlayed.where((item) {
      return item.title.toLowerCase().contains(query) ||
          item.subtitle.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

            // Recently played
            Expanded(
              child: SingleChildScrollView(
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

                    if (filteredItems.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: Text(
                            'No results found',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    else
                      ...filteredItems.map(
                            (item) => SearchRecentlyItem(
                          item: item,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}