import 'package:flutter/material.dart';

class ExploreSearchBar extends StatelessWidget {
  const ExploreSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFD9DDE0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.search,
            size: 18,
            color: Colors.grey,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Songs, Artists, Podcasts & More',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}