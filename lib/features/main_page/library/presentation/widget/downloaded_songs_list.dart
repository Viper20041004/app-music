import 'dart:io';
import 'package:app_music/core/navigation/app_navigator.dart';
import 'package:app_music/core/storage/local_song_storage.dart';
import 'package:app_music/features/main_page/library/data/song_model.dart';
import 'package:app_music/features/player/presentation/page/now_playing_screen.dart';
import 'package:app_music/features/player/presentation/widget/song_options_bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DownloadedSongsList extends StatelessWidget {
  const DownloadedSongsList({super.key});

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
    return ValueListenableBuilder<List<SongModel>>(
      valueListenable: LocalSongStorage.instance.downloadedSongsNotifier,
      builder: (context, songs, _) {
        if (songs.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
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
                  const Text(
                    'Chưa có bài hát nào được tải về',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Khi bạn nhấn "Download" ở bất kỳ bài hát nào, bài hát sẽ được lưu vào đây để nghe ngoại tuyến.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${songs.length} bài hát đã tải về',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    if (songs.isNotEmpty) {
                      AppNavigator.push(
                        context,
                        NowPlayingScreen(
                          song: songs.first,
                          playlistName: 'Downloaded Songs',
                        ),
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.play_circle_fill,
                    color: Color(0xFF00AFC4),
                    size: 20,
                  ),
                  label: const Text(
                    'Phát tất cả',
                    style: TextStyle(
                      color: Color(0xFF00AFC4),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: songs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final song = songs[index];
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
                    padding: const EdgeInsets.symmetric(vertical: 4),
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
          ],
        );
      },
    );
  }
}
