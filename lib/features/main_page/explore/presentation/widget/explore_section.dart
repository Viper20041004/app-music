
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
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 14),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 1.85,
          ),
          itemBuilder: (context, index) {
            return ExploreCard(
              item: items[index],
              category: title,
            );
          },
        ),
      ],
    );
  }
}