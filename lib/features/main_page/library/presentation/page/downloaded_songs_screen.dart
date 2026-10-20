import 'dart:io';
import 'package:app_music/core/navigation/app_navigator.dart';
import 'package:app_music/core/storage/local_song_storage.dart';
import 'package:app_music/features/main_page/library/data/song_model.dart';
import 'package:app_music/features/player/presentation/page/now_playing_screen.dart';
import 'package:app_music/features/player/presentation/widget/song_options_bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DownloadedSongsScreen extends StatefulWidget {
  const DownloadedSongsScreen({super.key});

  @override
  State<DownloadedSongsScreen> createState() => _DownloadedSongsScreenState();
}

class _DownloadedSongsScreenState extends State<DownloadedSongsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildArtwork(SongModel song) {
    const size = 56.0;

    if (song.networkImageUrl != null && song.networkImageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: song.networkImageUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: size,
          height: size,
          color: Colors.white10,
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFF00AFC4),
            ),
          ),
        ),
        errorWidget: (context, url, error) => _buildLocalOrAssetArtwork(song, size),
      );
    }

    return _buildLocalOrAssetArtwork(song, size);
  }

  Widget _buildLocalOrAssetArtwork(SongModel song, double size) {
    if (song.imagePath.isNotEmpty) {
      if (File(song.imagePath).existsSync()) {
        return Image.file(
          File(song.imagePath),
          width: size,
          height: size,
          fit: BoxFit.cover,
        );
      }
      return Image.asset(
        song.imagePath,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(size),
      );
    }
    return _buildPlaceholder(size);
  }

  Widget _buildPlaceholder(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.music_note,
        color: Colors.white54,
        size: 28,
      ),
    );
  }

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
            stops: [0.0, 0.2, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: ValueListenableBuilder<List<SongModel>>(
            valueListenable: LocalSongStorage.instance.downloadedSongsNotifier,
            builder: (context, songs, _) {
              final filteredSongs = _searchQuery.isEmpty
                  ? songs
                  : songs.where((s) {
                      final q = _searchQuery.toLowerCase();
                      return s.title.toLowerCase().contains(q) ||
                          s.artist.toLowerCase().contains(q);
                    }).toList();

              return Column(
                children: [
                  // Header Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Downloaded Songs',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00AFC4).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF00AFC4).withValues(alpha: 0.4),
                            ),
                          ),
                          child: Text(
                            '${songs.length} offline',
                            style: const TextStyle(
                              color: Color(0xFF00AFC4),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Search bar
                  if (songs.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(21),
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          onChanged: (val) {
                            setState(() {
                              _searchQuery = val.trim();
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Tìm kiếm trong bài hát đã tải...',
                            hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                            prefixIcon: const Icon(Icons.search, color: Colors.white38, size: 20),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.close, color: Colors.white54, size: 18),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {
                                        _searchQuery = '';
                                      });
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ),

                  // Action Buttons (Play All / Shuffle)
                  if (songs.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (filteredSongs.isNotEmpty) {
                                  AppNavigator.push(
                                    context,
                                    NowPlayingScreen(
                                      song: filteredSongs.first,
                                      playlistName: 'Downloaded Songs',
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.play_arrow, size: 20),
                              label: const Text('Phát tất cả'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00AFC4),
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                if (filteredSongs.isNotEmpty) {
                                  final shuffled = List<SongModel>.from(filteredSongs)..shuffle();
                                  AppNavigator.push(
                                    context,
                                    NowPlayingScreen(
                                      song: shuffled.first,
                                      playlistName: 'Downloaded Songs',
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.shuffle, size: 20),
                              label: const Text('Xáo trộn'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white38),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Songs List
                  Expanded(
                    child: filteredSongs.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.05),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.download_for_offline_outlined,
                                      size: 54,
                                      color: Colors.white38,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  Text(
                                    _searchQuery.isNotEmpty
                                        ? 'Không tìm thấy bài hát phù hợp'
                                        : 'Chưa có bài hát nào được tải về',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _searchQuery.isNotEmpty
                                        ? 'Hãy thử tìm kiếm với từ khóa khác'
                                        : 'Nhấn biểu tượng Download ở bất kỳ bài hát nào để nghe offline tại đây.',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                            itemCount: filteredSongs.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final song = filteredSongs[index];
                              return InkWell(
                                onTap: () {
                                  AppNavigator.push(
                                    context,
                                    NowPlayingScreen(
                                      song: song,
                                      playlistName: 'Downloaded Songs',
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: _buildArtwork(song),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              song.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.download_done_rounded,
                                                  color: Color(0xFF00AFC4),
                                                  size: 14,
                                                ),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    song.artist,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color: Colors.white54,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.more_vert,
                                          color: Colors.white54,
                                          size: 22,
                                        ),
                                        onPressed: () {
                                          showSongOptionsMenu(context, song);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
