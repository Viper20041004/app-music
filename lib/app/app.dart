
import 'package:app_music/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Musium',
      theme: AppTheme.darkTheme,
      home: const SplashPage(),
    );
  }
}