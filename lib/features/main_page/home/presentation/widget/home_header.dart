import 'package:app_music/app/theme/app_colors.dart';
import 'package:app_music/core/constant/app_assets.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary,
              width: 1.5,
            ),
            image: DecorationImage(
              image: AssetImage(AppAssets.avatar),
              fit: BoxFit.cover,
            ),
          ),
        ),

        const SizedBox(width: 12),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back!',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'chandramo',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        _HeaderButton(
          icon: AppAssets.iconBoard,
          onPressed: () {},
        ),

        _HeaderButton(
          icon: AppAssets.iconNotiImage,
          onPressed: () {},
        ),

        _HeaderButton(
          icon: AppAssets.iconSettingImage,
          onPressed: () {},
        ),
      ],
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final String icon;
  final VoidCallback onPressed;

  const _HeaderButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 34,
        minHeight: 34,
      ),
      icon: Image.asset(
        icon,
        width: 24,
        height: 24,
        fit: BoxFit.contain,
      )
    );
  }
}