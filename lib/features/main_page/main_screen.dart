import 'package:app_music/features/main_page/explore/presentation/page/explore_screen.dart';
import 'package:app_music/features/main_page/home/presentation/page/home_page.dart';
import 'package:app_music/features/main_page/home/presentation/widget/bottom_nav.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainPageState();
}

class _MainPageState extends State<MainScreen> {
  int currentIndex = 0;

  final pages = const [
    HomePage(),
    ExploreScreen(),
    _LibraryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: HomeBottomNav(
        currentIndex: currentIndex,
        onChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}

class _LibraryPage extends StatelessWidget {
  const _LibraryPage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Library'),
    );
  }
}