import 'package:app_music/features/home/presentation/widget/bottom_nav.dart';
import 'package:app_music/features/home/presentation/widget/continue_listening.dart';
import 'package:app_music/features/home/presentation/widget/home_header.dart';
import 'package:app_music/features/home/presentation/widget/recent_listening.dart';
import 'package:app_music/features/home/presentation/widget/top_mixes.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  void onNavigationChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF073C40),
              Color(0xFF071A1C),
              Color(0xFF0E0E0E),
              Color(0xFF0E0E0E),
            ],
            stops: [
              0.0,
              0.15,
              0.55,
              1.0,
            ],
          )
        ),
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  16,
                  20,
                  110,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const HomeHeader(),

                      const SizedBox(height: 28),

                      const SectionTitle(
                        title: 'Continue Listening',
                      ),

                      const SizedBox(height: 12),

                      const ContinueListening(),

                      const SizedBox(height: 30),

                      const SectionTitle(
                        title: 'Your Top Mixes',
                      ),

                      const SizedBox(height: 12),

                      const TopMixes(),

                      const SizedBox(height: 30),

                      const SectionTitle(
                        title: 'Based on your recent listening',
                      ),

                      const SizedBox(height: 14),

                      const RecentListening(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: HomeBottomNav(
        currentIndex: selectedIndex,
        onChanged: onNavigationChanged,
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
    );
  }
}