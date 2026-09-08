
import 'package:app_music/features/main_page/library/presentation/widget/albums_list.dart';
import 'package:app_music/features/main_page/library/presentation/widget/artist_list.dart';
import 'package:app_music/features/main_page/library/presentation/widget/folder_list.dart';
import 'package:app_music/features/main_page/library/presentation/widget/library_action.dart';
import 'package:app_music/features/main_page/library/presentation/widget/library_filter.dart';
import 'package:app_music/features/main_page/library/presentation/widget/library_header.dart';
import 'package:flutter/material.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryScreen> {
  int selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080A0B),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              10,
              100,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LibraryHeader(),
          
                const SizedBox(height: 24),
          
                LibraryFilter(
                  selectedIndex: selectedFilter,
                  onSelected: (index) {
                    setState(() {
                      selectedFilter = index;
                    });
                  },
                ),
          
                const SizedBox(height: 22),
          
                const LibraryActionItem(
                  icon: Icons.add,
                  title: 'Add New Playlist',
                ),
          
                const SizedBox(height: 14),
          
                const LibraryActionItem(
                  icon: Icons.favorite_border,
                  title: 'Your Liked Songs',
                ),
          
                const SizedBox(height: 24),
          
                const Text(
                  '⇅ Recently played',
                  style: TextStyle(
                    color: Color(0xFF45C8D0),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
          
                const SizedBox(height: 14),
          
                _buildContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (selectedFilter) {
      case 0:
        return const FoldersList();

      case 1:
        return const AlbumsList();

      case 2:
        return const ArtistList();

      case 3:
        return const AlbumsList();

      case 4:
        return const AlbumsList();

      default:
        return const AlbumsList();
    }
  }
}