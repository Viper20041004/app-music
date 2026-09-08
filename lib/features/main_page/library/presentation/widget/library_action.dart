import 'package:app_music/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LibraryActionItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const LibraryActionItem({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryDark,
          ),
          child: Icon(
            icon,
            color: Colors.black,
            size: 25,
          ),
        ),

        const SizedBox(width: 14),

        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}