import 'package:app_music/features/home/presentation/page/home_page.dart';
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vibe Music',
      theme: AppTheme.darkTheme,
      home: const HomePage(),
    );
  }
}