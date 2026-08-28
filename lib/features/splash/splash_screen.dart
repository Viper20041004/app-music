import 'dart:async';

import 'package:app_music/app/theme/app_colors.dart';
import 'package:app_music/core/constant/app_assets.dart';
import 'package:app_music/features/main_page/home/presentation/page/home_page.dart';
import 'package:app_music/features/main_page/main_screen.dart';

import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 2),
          () {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const MainScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  AppColors.background,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.logoImage,
              width: 150,
              fit: BoxFit.contain,
            ),
            Image.asset(
              AppAssets.musium,
              width: 150,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}