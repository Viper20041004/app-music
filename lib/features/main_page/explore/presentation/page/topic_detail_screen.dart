import 'package:app_music/features/main_page/explore/data/topic_data.dart';
import 'package:app_music/features/main_page/explore/data/topic_model.dart';
import 'package:app_music/features/main_page/explore/presentation/page/explore_screen.dart';
import 'package:app_music/features/main_page/explore/presentation/widget/topic_section_widget.dart';
import 'package:flutter/material.dart';

class TopicDetailScreen extends StatefulWidget {
  final ExploreItem topic;

  const TopicDetailScreen({
    super.key,
    required this.topic,
  });

  @override
  State<TopicDetailScreen> createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends State<TopicDetailScreen> {
  late List<TopicSection> _allSections;
  int _selectedFilterIndex = 0;

  @override
  void initState() {
    super.initState();
    _allSections = TopicData.getSectionsForTopic(widget.topic.title);
  }

  @override
  Widget build(BuildContext context) {
    // Filter sections based on selected filter
    final displayedSections = _selectedFilterIndex == 0
        ? _allSections
        : [_allSections[_selectedFilterIndex - 1]];

    return Scaffold(
      backgroundColor: const Color(0xFF080A0B),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF073C40),
              Color(0xFF073C40),
              Color(0xFF071A1C),
              Color(0xFF0E0E0E),
            ],
            stops: [
              0.0,
              0.15,
              0.55,
              1.0,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar Header
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 26,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        widget.topic.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Container(
                    //   width: 40,
                    //   height: 40,
                    //   decoration: BoxDecoration(
                    //     color: Colors.white.withValues(alpha: 0.08),
                    //     shape: BoxShape.circle,
                    //   ),
                    //   child: IconButton(
                    //     icon: const Icon(
                    //       Icons.search,
                    //       color: Colors.white,
                    //       size: 20,
                    //     ),
                    //     padding: EdgeInsets.zero,
                    //     onPressed: () {},
                    //   ),
                    // ),
                  ],
                ),
              ),

              // Filter Chips
              if (_allSections.length > 1)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _allSections.length + 1,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final isSelected = _selectedFilterIndex == index;
                        final label =
                            index == 0 ? 'Tất cả' : _allSections[index - 1].title;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedFilterIndex = index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF00AFC4)
                                  : Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF00AFC4)
                                    : Colors.white.withValues(alpha: 0.12),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                label,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.white70,
                                  fontSize: 13,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

              // Sections content
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(top: 8, bottom: 120),
                  itemCount: displayedSections.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 28),
                  itemBuilder: (context, index) {
                    return TopicSectionWidget(
                      section: displayedSections[index],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
