import 'package:app_music/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LibraryFilter extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const LibraryFilter({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  static const filters = [
    'Folders',
    'Playlists',
    'Artists',
    'Albums',
    'Podcasts',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) {
          return const SizedBox(width: 12);
        },
        itemBuilder: (context, index) {
          final selected = selectedIndex == index;

          return GestureDetector(
            onTap: () => onSelected(index),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                gradient: selected
                    ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1797A8),
                    Color(0xFF00C2CB),
                  ],
                )
                    : null,
                color: selected ? null : Colors.transparent,
                border: Border.all(
                  color: selected
                      ? AppColors.primaryDark
                      : Colors.white70,
                  width: 0.7,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                filters[index],
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: selected
                      ? FontWeight.w500
                      : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}