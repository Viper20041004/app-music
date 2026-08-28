
import 'package:app_music/features/main_page/explore/presentation/page/explore_screen.dart';
import 'package:flutter/material.dart';

class ExploreCard extends StatelessWidget {
  final ExploreItem item;

  const ExploreCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        color: item.color,
        child: Stack(
          children: [
            Positioned(
              top: 12,
              left: 10,
              child: Text(
                item.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),

            Positioned(
              right: -20,
              bottom: -15,
              child: Transform.rotate(
                angle: 0,
                child: ClipRRect(
                  // borderRadius: BorderRadius.circular(2),
                  child: Image.asset(
                    item.image,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}