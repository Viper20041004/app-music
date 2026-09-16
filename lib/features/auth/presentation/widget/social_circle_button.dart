import 'package:flutter/material.dart';

class SocialCircleButton extends StatelessWidget {
  final String? iconAsset;
  final IconData? iconData;
  final VoidCallback onPressed;

  const SocialCircleButton({
    super.key,
    this.iconAsset,
    this.iconData,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF1F222A),
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF2E323E),
            width: 1,
          ),
        ),
        child: Center(
          child: iconAsset != null
              ? Image.asset(
                  iconAsset!,
                  width: 26,
                  height: 26,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      iconData ?? Icons.login,
                      color: Colors.white,
                      size: 26,
                    );
                  },
                )
              : Icon(
                  iconData ?? Icons.login,
                  color: Colors.white,
                  size: 26,
                ),
        ),
      ),
    );
  }
}
