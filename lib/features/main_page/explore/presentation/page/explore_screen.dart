import 'dart:async';

import 'package:app_music/core/constant/app_assets.dart';
import 'package:app_music/features/main_page/explore/data/explore_models.dart';
import 'package:app_music/features/main_page/explore/domain/explore_search_service.dart';
import 'package:app_music/features/main_page/explore/presentation/widget/explore_header.dart';
import 'package:app_music/features/main_page/explore/presentation/widget/explore_search_bar.dart';
import 'package:app_music/features/main_page/explore/presentation/widget/explore_search_filter_bar.dart';
import 'package:app_music/features/main_page/explore/presentation/widget/explore_search_results_view.dart';
import 'package:app_music/features/main_page/explore/presentation/widget/explore_section.dart';
import 'package:flutter/material.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();

  static const topGenres = [
    ExploreItem(
      title: 'V-Rap',
      image: AppAssets.vrapImage,
    ),
    ExploreItem(
      title: 'V-Pop',
      image: AppAssets.vpopImage,
    ),
    ExploreItem(
      title: 'Pop',
      image: AppAssets.popImage,
    ),
    ExploreItem(
      title: 'Remix',
      image: AppAssets.remixImage,
    ),
    ExploreItem(
      title: 'Bolero',
      image: AppAssets.boleroImage,
    ),
    ExploreItem(
      title: 'Chill Out',
      image: AppAssets.chillOutImage,
    ),
    ExploreItem(
      title: 'TikTok',
      image: AppAssets.tikTokImage,
    ),
    ExploreItem(
      title: 'C-Pop',
      image: AppAssets.cpopImage,
    ),
    ExploreItem(
      title: 'Relax',
      image: AppAssets.relaxImage,
    ),
    ExploreItem(
      title: 'Sad',
      image: AppAssets.sadImage,
    ),
  ];
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ExploreSearchService _searchService = ExploreSearchService();

  Timer? _debounceTimer;
  bool _isLoading = false;
  String? _errorMessage;
  ExploreSearchResult? _searchResult;
  ExploreSearchFilter _selectedFilter = ExploreSearchFilter.all;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();

    if (value.trim().isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = null;
        _searchResult = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      _performSearch(value);
    });
  }

  Future<void> _performSearch(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = null;
        _searchResult = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _searchService.search(cleanQuery);
      if (!mounted) return;

      setState(() {
        _searchResult = result;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Failed to load search results: $e';
        _isLoading = false;
      });
    }
  }

  void _clearSearch() {
    _debounceTimer?.cancel();
    _searchController.clear();
    setState(() {
      _isLoading = false;
      _errorMessage = null;
      _searchResult = null;
      _selectedFilter = ExploreSearchFilter.all;
    });
  }

  void _onSelectKeyword(String keyword) {
    _searchController.text = keyword;
    _performSearch(keyword);
  }

  @override
  Widget build(BuildContext context) {
    final hasSearchQuery = _searchController.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFF080A0B),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF073C40),
              Color(0xFF073C40),
              Color(0xFF071A1C),
              Color(0xFF0E0E0E),
            ],
            stops: [
              0.0,
              0.15,
              0.55,
              1.0,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ExploreHeader(),
                const SizedBox(height: 18),
                ExploreSearchBar(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  isLoading: _isLoading,
                  onChanged: _onSearchChanged,
                  onSubmitted: _performSearch,
                  onClear: _clearSearch,
                ),
                if (!hasSearchQuery) ...[
                  const SizedBox(height: 24),
                  const ExploreSection(
                    title: 'Topics',
                    items: ExploreScreen.topGenres,
                  ),
                ] else ...[
                  const SizedBox(height: 16),
                  ExploreSearchFilterBar(
                    selectedFilter: _selectedFilter,
                    result: _searchResult,
                    onFilterSelected: (filter) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                  ),
                  const SizedBox(height: 18),
                  _buildSearchBody(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBody() {
    if (_isLoading && _searchResult == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: Color(0xFF00AFC4),
                strokeWidth: 2.5,
              ),
              SizedBox(height: 16),
              Text(
                'Searching...',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.redAccent,
                size: 40,
              ),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _performSearch(_searchController.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00AFC4),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    if (_searchResult != null) {
      return ExploreSearchResultsView(
        result: _searchResult!,
        selectedFilter: _selectedFilter,
        query: _searchController.text.trim(),
        onFilterChange: (filter) {
          setState(() {
            _selectedFilter = filter;
          });
        },
        onSelectKeyword: _onSelectKeyword,
      );
    }

    return const SizedBox.shrink();
  }
}

class ExploreItem {
  final String title;
  final String image;
  final Color? color;
  final String? searchQuery;
  final String? description;
  final VoidCallback? onTap;

  const ExploreItem({
    required this.title,
    required this.image,
    this.color,
    this.searchQuery,
    this.description,
    this.onTap,
  });
}