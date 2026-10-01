import 'package:app_music/core/navigation/app_navigator.dart';
import 'package:app_music/features/main_page/library/data/playlist_model.dart';
import 'package:app_music/features/main_page/library/data/song_model.dart';
import 'package:app_music/features/player/data/song_repository.dart';
import 'package:app_music/features/player/presentation/page/now_playing_screen.dart';
import 'package:app_music/features/player/presentation/widget/song_options_bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PlaylistDetailScreen extends StatefulWidget {
  final PlaylistModel playlist;

  const PlaylistDetailScreen({
    super.key,
    required this.playlist,
  });

  @override
  State<PlaylistDetailScreen> createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  final SongRepository _songRepository = SongRepository();
  List<SongModel> songs = [];
  bool isLoading = true;
  bool _showAll = false;
  static const int _initialSongLimit = 20;

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    setState(() {
      isLoading = true;
      _showAll = false;
    });
    try {
      final fetched = await _songRepository.fetchSongs();
      if (mounted) {
        setState(() {
          songs = fetched;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget _buildSongImage(SongModel song) {
    if (song.networkImageUrl != null && song.networkImageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: song.networkImageUrl!,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: 60,
          height: 60,
          color: Colors.white10,
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFF00AFC4),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Image.asset(
          song.imagePath,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: 60,
            height: 60,
            color: Colors.white12,
            child: const Icon(Icons.music_note, color: Colors.white54),
          ),
        ),
      );
    }
    return Image.asset(
      song.imagePath,
      width: 60,
      height: 60,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        width: 60,
        height: 60,
        color: Colors.white12,
        child: const Icon(Icons.music_note, color: Colors.white54),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fromCategory =
        (widget.playlist.fromCategory ?? 'PLAYLISTS').toUpperCase();
    final description =
        widget.playlist.description ?? 'soft, chill, dreamy, lo-fi beats';
    final displayedSongs =
        _showAll ? songs : songs.take(_initialSongLimit).toList();

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
            children: [
              // Top Bar Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Text(
                      'FROM "$fromCategory"',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // Body Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),

                      // Playlist Artwork
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          widget.playlist.imagePath,
                          width: 220,
                          height: 220,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Playlist Title
                      Text(
                        widget.playlist.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Playlist Description
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Songs List
                      if (isLoading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: CircularProgressIndicator(
                            color: Color(0xFF00AFC4),
                          ),
                        )
                      else if (songs.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.music_off_outlined,
                                size: 48,
                                color: Colors.white38,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Không tìm thấy bài hát nào',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: _loadSongs,
                                icon: const Icon(Icons.refresh, size: 18),
                                label: const Text('Thử lại'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00AFC4),
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        )
                      else ...[
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: displayedSongs.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final song = displayedSongs[index];
                            return GestureDetector(
                              onTap: () {
                                AppNavigator.push(
                                  context,
                                  NowPlayingScreen(
                                    song: song,
                                    playlistName: widget.playlist.title,
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: _buildSongImage(song),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          song.title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          song.artist,
                                          style: const TextStyle(
                                            color: Colors.white54,
                                            fontSize: 14,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
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
                            );
                          },
                        ),
                        if (songs.length > _initialSongLimit) ...[
                          const SizedBox(height: 20),
                          Center(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _showAll = !_showAll;
                                });
                              },
                              borderRadius: BorderRadius.circular(25),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: const Color(0xFF00AFC4)
                                        .withValues(alpha: 0.4),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _showAll
                                          ? 'Show less'
                                          : 'Show more (${songs.length - _initialSongLimit})',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Icon(
                                      _showAll
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: const Color(0xFF00AFC4),
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],

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
