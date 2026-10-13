import 'package:app_music/core/constant/app_assets.dart';
import 'package:app_music/core/navigation/app_navigator.dart';
import 'package:app_music/features/main_page/explore/data/explore_models.dart';
import 'package:app_music/features/main_page/explore/domain/explore_search_service.dart';
import 'package:app_music/features/main_page/library/data/song_model.dart';
import 'package:app_music/features/player/data/song_repository.dart';
import 'package:app_music/features/player/presentation/page/now_playing_screen.dart';
import 'package:app_music/features/player/presentation/widget/song_options_bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ArtistDetailScreen extends StatefulWidget {
  final ExploreArtist? artist;
  final String? name;
  final String? avatarUrl;
  final String? bannerUrl;
  final int followersCount;
  final String uploader;
  final List<SongModel>? initialSongs;

  const ArtistDetailScreen({
    super.key,
    this.artist,
    this.name,
    this.avatarUrl,
    this.bannerUrl,
    this.followersCount = 140322,
    this.uploader = 'VIVI ENM',
    this.initialSongs,
  });

  @override
  State<ArtistDetailScreen> createState() => _ArtistDetailScreenState();
}

class _ArtistDetailScreenState extends State<ArtistDetailScreen> {
  bool _isFollowing = false;
  bool _isLoading = false;
  List<SongModel> _songs = [];

  String get artistName =>
      widget.artist?.name ?? widget.name ?? 'Sơn Tùng M-TP';

  String? get avatarUrl => widget.artist?.imageUrl ?? widget.avatarUrl;

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    if (widget.initialSongs != null && widget.initialSongs!.isNotEmpty) {
      setState(() {
        _songs = widget.initialSongs!;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    List<SongModel> fetchedSongs = [];

    try {
      // Thử gọi search API với tên nghệ sĩ
      final searchService = ExploreSearchService();
      final searchResult = await searchService.search(artistName);

      if (searchResult.songs.isNotEmpty) {
        fetchedSongs = searchResult.songs;
      } else {
        // Fallback gọi fetchSongs từ repository
        final repo = SongRepository();
        final allSongs = await repo.fetchSongs(query: artistName);
        if (allSongs.isNotEmpty) {
          fetchedSongs = allSongs;
        }
      }
    } catch (_) {}

    // Nếu API không có bài hát hoặc offline, cung cấp danh sách top songs mặc định phù hợp với nghệ sĩ
    if (fetchedSongs.isEmpty) {
      fetchedSongs = _getDefaultSongsForArtist(artistName);
    }

    if (mounted) {
      setState(() {
        _songs = fetchedSongs;
        _isLoading = false;
      });
    }
  }

  List<SongModel> _getDefaultSongsForArtist(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('sơn tùng') || lower.contains('son tung') || lower.contains('m-tp') || lower.contains('mtp')) {
      return [
        const SongModel(
          id: 101,
          title: 'Nơi Này Có Anh',
          artist: 'Sơn Tùng M-TP',
          album: 'VIVI ENM',
          imagePath: AppAssets.artistImage7,
          duration: 260, // 04:20
        ),
        const SongModel(
          id: 102,
          title: 'Âm Thầm Bên Em',
          artist: 'Sơn Tùng M-TP',
          album: 'VIVI ENM',
          imagePath: AppAssets.artistImage7,
          duration: 291, // 04:51
        ),
        const SongModel(
          id: 103,
          title: 'Chạy Ngay Đi',
          artist: 'Sơn Tùng M-TP',
          album: 'VIVI ENM',
          imagePath: AppAssets.artistImage7,
          duration: 247, // 04:07
        ),
        const SongModel(
          id: 104,
          title: 'Lạc Trôi',
          artist: 'Sơn Tùng M-TP',
          album: 'VIVI ENM',
          imagePath: AppAssets.artistImage7,
          duration: 232, // 03:52
        ),
        const SongModel(
          id: 105,
          title: 'Chúng Ta Của Hiện Tại',
          artist: 'Sơn Tùng M-TP',
          album: 'VIVI ENM',
          imagePath: AppAssets.artistImage7,
          duration: 301, // 05:01
        ),
      ];
    }

    // Default template cho bất kỳ artist nào khác
    return [
      SongModel(
        id: 201,
        title: 'Top Song 1',
        artist: name,
        album: widget.uploader,
        imagePath: AppAssets.genImage1,
        duration: 215,
      ),
      SongModel(
        id: 202,
        title: 'Top Song 2',
        artist: name,
        album: widget.uploader,
        imagePath: AppAssets.genImage2,
        duration: 245,
      ),
      SongModel(
        id: 203,
        title: 'Top Song 3',
        artist: name,
        album: widget.uploader,
        imagePath: AppAssets.genImage3,
        duration: 198,
      ),
    ];
  }

  String _formatDuration(int? seconds) {
    if (seconds == null || seconds <= 0) return '04:20';
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _onPlayAll() {
    if (_songs.isNotEmpty) {
      AppNavigator.push(
        context,
        NowPlayingScreen(
          song: _songs.first,
          playlistName: artistName,
        ),
      );
    }
  }

  void _onPlaySong(SongModel song) {
    AppNavigator.push(
      context,
      NowPlayingScreen(
        song: song,
        playlistName: artistName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111415),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header / Banner Section
            _buildHeaderBanner(),

            // Top Songs Section
            _buildTopSongsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBanner() {
    return Stack(
      children: [
        // Background banner image
        SizedBox(
          height: 310,
          width: double.infinity,
          child: _buildBannerImage(),
        ),

        // Gradient dark overlay
        Container(
          height: 310,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.35),
                Colors.black.withValues(alpha: 0.65),
                const Color(0xFF111415),
              ],
              stops: const [0.0, 0.65, 1.0],
            ),
          ),
        ),

        // Back button on top
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Artist Info (Avatar, Name, Followers, Follow, Play All)
        Positioned(
          left: 20,
          right: 20,
          bottom: 24,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circular Avatar
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.8),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: _buildAvatarImage(),
                ),
              ),

              const SizedBox(width: 18),

              // Artist details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Artist name
                    Text(
                      artistName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Followers and Follow button
                    // Row(
                    //   children: [
                    //     Text(
                    //       '${widget.followersCount} followers',
                    //       style: TextStyle(
                    //         color: Colors.white.withValues(alpha: 0.75),
                    //         fontSize: 13,
                    //         fontWeight: FontWeight.w400,
                    //       ),
                    //     ),
                    //     const SizedBox(width: 14),
                    //     GestureDetector(
                    //       onTap: () {
                    //         setState(() {
                    //           _isFollowing = !_isFollowing;
                    //         });
                    //       },
                    //       child: AnimatedContainer(
                    //         duration: const Duration(milliseconds: 200),
                    //         padding: const EdgeInsets.symmetric(
                    //           horizontal: 18,
                    //           vertical: 4,
                    //         ),
                    //         decoration: BoxDecoration(
                    //           color: _isFollowing
                    //               ? Colors.white
                    //               : Colors.transparent,
                    //           borderRadius: BorderRadius.circular(20),
                    //           border: Border.all(
                    //             color: Colors.white,
                    //             width: 1.2,
                    //           ),
                    //         ),
                    //         child: Text(
                    //           _isFollowing ? 'Following' : 'Follow',
                    //           style: TextStyle(
                    //             color: _isFollowing
                    //                 ? Colors.black
                    //                 : Colors.white,
                    //             fontSize: 12,
                    //             fontWeight: FontWeight.w600,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    const SizedBox(height: 14),

                    // Play all button
                    GestureDetector(
                      onTap: _onPlayAll,
                      child: Container(
                        height: 38,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00C2CB),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00C2CB).withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.play_arrow,
                              color: Colors.black,
                              size: 20,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Play all',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBannerImage() {
    if (widget.bannerUrl != null && widget.bannerUrl!.isNotEmpty) {
      if (widget.bannerUrl!.startsWith('http')) {
        return CachedNetworkImage(
          imageUrl: widget.bannerUrl!,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => Image.asset(
            AppAssets.sontungBanner,
            fit: BoxFit.cover,
          ),
        );
      }
      return Image.asset(
        widget.bannerUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          AppAssets.sontungBanner,
          fit: BoxFit.cover,
        ),
      );
    }

    // Default banner: dùng sontungBanner đã import
    return Image.asset(
      AppAssets.sontungBanner,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        AppAssets.artistImage7,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildAvatarImage() {
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      if (avatarUrl!.startsWith('http')) {
        return CachedNetworkImage(
          imageUrl: avatarUrl!,
          fit: BoxFit.cover,
          // placeholder: (context, url) => Container(color: Colors.white10),
          errorWidget: (context, url, error) => Image.asset(
            AppAssets.artistImage7,
            fit: BoxFit.cover,
          ),
        );
      }
      return Image.asset(
        avatarUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          AppAssets.artistImage7,
          fit: BoxFit.cover,
        ),
      );
    }

    return Image.asset(
      AppAssets.artistImage7,
      fit: BoxFit.cover,
    );
  }

  Widget _buildTopSongsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top songs',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: 16),

          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF00C2CB),
                  strokeWidth: 2.5,
                ),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 450;
                final tableWidget = Column(
                  children: [
                    // Table Header
                    _buildTableHeader(),

                    // const SizedBox(height: 8),

                    // Song List
                    ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _songs.length,
                      itemBuilder: (context, index) {
                        final song = _songs[index];
                        return _buildSongRow(index + 1, song);
                      },
                    ),
                  ],
                );

                if (isNarrow) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: 450,
                      child: tableWidget,
                    ),
                  );
                }

                return tableWidget;
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: const Row(
        children: [
          // Index #
          SizedBox(
            width: 24,
            child: Text(
              '#',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Title
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.only(left: 6),
              child: Text(
                'Title',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // Uploader
          // Expanded(
          //   flex: 3,
          //   child: Text(
          //     'Uploader',
          //     style: TextStyle(
          //       color: Colors.white54,
          //       fontSize: 13,
          //       fontWeight: FontWeight.w600,
          //     ),
          //   ),
          // ),

          // Artist
          Expanded(
            flex: 3,
            child: Text(
              'Artist',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Duration clock icon
          SizedBox(
            width: 46,
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.access_time,
                color: Colors.white54,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSongRow(int index, SongModel song) {
    final uploaderName = song.album != null && song.album!.isNotEmpty
        ? song.album!
        : widget.uploader;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onPlaySong(song),
        onLongPress: () => showSongOptionsMenu(context, song),
        borderRadius: BorderRadius.circular(8),
        hoverColor: Colors.white.withValues(alpha: 0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              // Index #
              SizedBox(
                width: 24,
                child: Text(
                  '$index',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Title (Artwork + Song Title)
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: _buildSongArtwork(song),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          song.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Uploader
              // Expanded(
              //   flex: 3,
              //   child: Row(
              //     children: [
              //       Container(
              //         width: 15,
              //         height: 15,
              //         decoration: const BoxDecoration(
              //           color: Colors.white,
              //           shape: BoxShape.circle,
              //         ),
              //         child: const Center(
              //           child: Icon(
              //             Icons.verified_user_rounded,
              //             color: Color(0xFF003366),
              //             size: 11,
              //           ),
              //         ),
              //       ),
              //       const SizedBox(width: 6),
              //       Expanded(
              //         child: Text(
              //           uploaderName,
              //           style: TextStyle(
              //             color: Colors.white.withValues(alpha: 0.85),
              //             fontSize: 13,
              //             fontWeight: FontWeight.w500,
              //           ),
              //           maxLines: 1,
              //           overflow: TextOverflow.ellipsis,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // Artist
              Expanded(
                flex: 3,
                child: Text(
                  song.artist.isNotEmpty ? song.artist : artistName,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Duration
              SizedBox(
                width: 46,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    _formatDuration(song.duration),
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSongArtwork(SongModel song) {
    const size = 42.0;

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
        ),
        errorWidget: (context, url, error) => _buildFallbackArtwork(song, size),
      );
    }
    return _buildFallbackArtwork(song, size);
  }

  Widget _buildFallbackArtwork(SongModel song, double size) {
    return Image.asset(
      song.imagePath.isNotEmpty ? song.imagePath : AppAssets.artistImage7,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        width: size,
        height: size,
        color: const Color(0xFF1E2629),
        child: const Icon(
          Icons.music_note,
          color: Color(0xFF00C2CB),
          size: 20,
        ),
      ),
    );
  }
}
