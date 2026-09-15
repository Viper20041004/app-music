import 'package:app_music/core/constant/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:app_music/features/splash/widget/background_circle.dart';
import 'package:app_music/features/splash/widget/welcome_bottom.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF43BDD0),
      body: Container(

        child: Stack(
          children: [
            // =========================
            // BACKGROUND
            // =========================
            Positioned.fill(
              child: Container(
                color: const Color(0xFF43BDD0),
              ),
            ),
        
            // =========================
            // CIRCLE 1
            // =========================
            Positioned(
              top: 50,
              left: 15,
              child: BackgroundCircle(
                size: 120,
              ),
            ),
        
            // =========================
            // CIRCLE 2
            // =========================
            Positioned(
              top: 50,
              right: 35,
              child: BackgroundCircle(
                size: 100,
              ),
            ),
        
            // =========================
            // CIRCLE 3
            // =========================
            Positioned(
              top: 200,
              right: 20,
              child: BackgroundCircle(
                size: 80,
              ),
            ),
        
            // =========================
            // IMAGE
            // =========================
            Positioned(
              top: -60,
              left: -35,
              right: -35,
              bottom: 220,
              child: Image.asset(
                fit: BoxFit.contain,
                AppAssets.welcomeImage,
              ),
            ),
        
            // =========================
            // BOTTOM CONTENT
            // =========================
            Positioned(
              left: 0,
              top: 600,
              right: 0,
              bottom: 0,
              child: WelcomeBottomContent(),
            ),
          ],
        ),
      ),
    );
  }
}