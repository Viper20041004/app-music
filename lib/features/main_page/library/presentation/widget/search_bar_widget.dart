import 'package:app_music/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;

  const SearchBarWidget({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white70,
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
        cursorColor: AppColors.primaryDark,
        decoration: const InputDecoration(
          hintText: 'Browse Library',
          hintStyle: TextStyle(
            color: Colors.white54,
            fontSize: 15,
          ),
          prefixIcon: SizedBox(
            width: 1,
          ),
          suffixIcon: Icon(
            Icons.search,
            color: Colors.white,
            size: 17,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: 10,
          ),
        ),
      ),
    );
  }
}