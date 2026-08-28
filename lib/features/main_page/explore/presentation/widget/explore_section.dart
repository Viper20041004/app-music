
import 'package:app_music/features/main_page/explore/presentation/page/explore_screen.dart';
import 'package:app_music/features/main_page/explore/presentation/widget/explore_card.dart';
import 'package:flutter/material.dart';

class ExploreSection extends StatelessWidget {
  final String title;
  final List<ExploreItem> items;

  const ExploreSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 12),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 20,
            childAspectRatio: 1.7,
          ),
          itemBuilder: (context, index) {
            return ExploreCard(
              item: items[index],
            );
          },
        ),
      ],
    );
  }
}