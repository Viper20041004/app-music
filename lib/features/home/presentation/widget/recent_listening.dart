import 'package:flutter/material.dart';

class RecentListening extends StatelessWidget {
  const RecentListening({super.key});

  static const images = [
    'https://picsum.photos/500/700?20',
    'https://picsum.photos/500/700?21',
    'https://picsum.photos/500/700?22',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 205,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) {
          return const SizedBox(width: 14);
        },
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Image.network(
              images[index],
              width: 128,
              height: 205,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}