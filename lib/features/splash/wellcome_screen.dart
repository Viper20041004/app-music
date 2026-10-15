import 'dart:math' as math;

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
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            final shortestSide = math.min(width, height);

            return Stack(
              clipBehavior: Clip.none,
              children: [
                // BACKGROUND
                const Positioned.fill(
                  child: ColoredBox(
                    color: Color(0xFF43BDD0),
                  ),
                ),

                // CIRCLE 1
                Positioned(
                  top: height * 0.04,
                  left: width * 0.04,
                  child: BackgroundCircle(
                    size: shortestSide * 0.30,
                  ),
                ),

                // CIRCLE 2
                Positioned(
                  top: height * 0.04,
                  right: width * 0.08,
                  child: BackgroundCircle(
                    size: shortestSide * 0.25,
                  ),
                ),

                // CIRCLE 3
                Positioned(
                  top: height * 0.25,
                  right: width * 0.04,
                  child: BackgroundCircle(
                    size: shortestSide * 0.20,
                  ),
                ),

                // WELCOME IMAGE
                Positioned(
                  top: height * 0.02,
                  left: -width * 0.06,
                  right: -width * 0.06,
                  bottom: height * 0.28,
                  child: Image.asset(
                    AppAssets.welcomeImage,
                    fit: BoxFit.contain,
                  ),
                ),

                // BOTTOM CONTENT
                Positioned(
                  left: 0,
                  right: 0,
                  top: height * 0.62,
                  bottom: 0,
                  child: WelcomeBottomContent(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}