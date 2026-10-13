import 'package:app_music/app/theme/app_colors.dart';
import 'package:app_music/features/main_page/explore/data/explore_models.dart';
import 'package:flutter/material.dart';

class ExploreSearchFilterBar extends StatelessWidget {
  final ExploreSearchFilter selectedFilter;
  final ValueChanged<ExploreSearchFilter> onFilterSelected;
  final ExploreSearchResult? result;

  const ExploreSearchFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
    this.result,
  });

  int? _getCount(ExploreSearchFilter filter) {
    if (result == null) return null;
    switch (filter) {
      case ExploreSearchFilter.all:
        return result!.totalCount;
      case ExploreSearchFilter.song:
        return result!.songs.length;
      case ExploreSearchFilter.artist:
        return result!.artists.length;
      case ExploreSearchFilter.album:
        return result!.albums.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: ExploreSearchFilter.values.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = ExploreSearchFilter.values[index];
          final isSelected = selectedFilter == filter;
          final count = _getCount(filter);

          return GestureDetector(
            onTap: () => onFilterSelected(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF1797A8),
                          Color(0xFF00C2CB),
                        ],
                      )
                    : null,
                color: isSelected ? null : Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryDark
                      : Colors.white.withValues(alpha: 0.12),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    filter.label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  if (count != null) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.black.withValues(alpha: 0.2)
                            : Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$count',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white60,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
