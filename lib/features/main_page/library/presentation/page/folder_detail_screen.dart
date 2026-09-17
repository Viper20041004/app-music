import 'package:app_music/core/constant/app_assets.dart';
import 'package:app_music/core/navigation/app_navigator.dart';
import 'package:app_music/features/main_page/library/data/folder_model.dart';
import 'package:app_music/features/main_page/library/data/playlist_model.dart';
import 'package:app_music/features/main_page/library/presentation/page/playlist_detail_screen.dart';
import 'package:flutter/material.dart';

class FolderDetailScreen extends StatelessWidget {
  final FolderModel folder;

  const FolderDetailScreen({
    super.key,
    required this.folder,
  });

  static const List<PlaylistModel> samplePlaylists = [
    PlaylistModel(
      title: 'current favorites',
      songCount: '20 songs',
      imagePath: AppAssets.libraryImage1,
      description: 'soft, chill, dreamy, lo-fi beats',
    ),
    PlaylistModel(
      title: '3:00am vibes',
      songCount: '18 songs',
      imagePath: AppAssets.libraryImage2,
      description: 'late night vibes & ambient chill',
    ),
    PlaylistModel(
      title: 'Lofi Loft',
      songCount: '63 songs',
      imagePath: AppAssets.libraryImage3,
      description: 'soft, chill, dreamy, lo-fi beats',
    ),
    PlaylistModel(
      title: 'rain on my window',
      songCount: '32 songs',
      imagePath: AppAssets.libraryImage4,
      description: 'relaxing rain & calming melodies',
    ),
    PlaylistModel(
      title: 'Anime OSTs',
      songCount: '20 songs',
      imagePath: AppAssets.animeSongImage,
      description: 'best anime original soundtracks',
    ),
  ];

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
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        folder.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),

                      // Sort By Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Sort By',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: const Row(
                              children: [
                                Text(
                                  'Recently played',
                                  style: TextStyle(
                                    color: Color(0xFF00AFC4),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '⇅',
                                  style: TextStyle(
                                    color: Color(0xFF00AFC4),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // Add New Playlist Action Row
                      GestureDetector(
                        onTap: () {
                          debugPrint('Add New Playlist tapped');
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                color: Color(0xFF00AFC4),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Color(0xFF080A0B),
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              'Add New Playlist',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Playlist Items List
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: samplePlaylists.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 20),
                        itemBuilder: (context, index) {
                          final playlist = samplePlaylists[index];
                          return GestureDetector(
                            onTap: () {
                              AppNavigator.push(
                                context,
                                PlaylistDetailScreen(
                                  playlist: PlaylistModel(
                                    title: playlist.title,
                                    songCount: playlist.songCount,
                                    imagePath: playlist.imagePath,
                                    description: playlist.description,
                                    fromCategory: folder.name,
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    playlist.imagePath,
                                    width: 75,
                                    height: 75,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        playlist.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        playlist.songCount,
                                        style: const TextStyle(
                                          color: Colors.white54,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
