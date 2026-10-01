import 'dart:math';

import 'package:app_music/features/main_page/library/data/song_model.dart';
import 'package:app_music/features/player/presentation/widget/song_options_bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class NowPlayingScreen extends StatefulWidget {
  final SongModel song;
  final String playlistName;

  const NowPlayingScreen({
    super.key,
    required this.song,
    this.playlistName = 'Lofi Loft',
  });

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  bool isLiked = false;
  bool isShuffle = false;
  bool isRepeat = false;
  bool isLyricsExpanded = false;
  bool isLoading = true;
  String? errorMessage;

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  List<String> _getLyricsLines() {
    final rawLyrics = widget.song.lyrics;
    final text = (rawLyrics != null && rawLyrics.trim().isNotEmpty)
        ? rawLyrics
        : "You never look at the skyCause you think it's too highYou never look at the starsCause you think they're too farYou never look at the sunCause you think you might burnWaiting for a sign to comeBefore taking your turnClose your eyes and breathe it inA brand new melody beginsLet the music take controlAnd heal the rhythm of your soul";

    // Gom moi ky tu xuong dong thanh khoang trang de chuan hoa ve 1 dong
    final normalized = text
        .replaceAll('\r\n', ' ')
        .replaceAll('\r', ' ')
        .replaceAll('\n', ' ')
        .replaceAll('\t', ' ')
        .trim();

    // Tach tai khoang trang ngay truoc chu hoa (chu hoa = dau cau moi)
    // Vi du: "hello world Foo bar" -> ["hello world", "Foo bar"]
    final lines = normalized
        .splitMapJoin(
          RegExp(r' (?=[A-Z])'),
          onMatch: (_) => '\x00',
          onNonMatch: (s) => s,
        )
        .split('\x00')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    return lines;
  }

  late List<Color> gradientColors;

  final gradients = [
    // Spotify Green
    [
      const Color(0xFF1DB954),
      const Color(0xFF0E3B24),
      const Color(0xFF0E0E0E),
    ],

    // Deep Spotify Green
    [
      const Color(0xFF169B45),
      const Color(0xFF0B3020),
      const Color(0xFF0E0E0E),
    ],

    // Green / Teal
    [
      const Color(0xFF16A085),
      const Color(0xFF0B3A34),
      const Color(0xFF0E0E0E),
    ],

    // Cyan / Green
    [
      const Color(0xFF159A8A),
      const Color(0xFF0A3531),
      const Color(0xFF0E0E0E),
    ],

    // Blue
    [
      const Color(0xFF246B8F),
      const Color(0xFF102E3D),
      const Color(0xFF0E0E0E),
    ],

    // Deep Blue
    [
      const Color(0xFF315A8C),
      const Color(0xFF172C47),
      const Color(0xFF0E0E0E),
    ],

    // Blue / Green
    [
      const Color(0xFF178F78),
      const Color(0xFF0A332C),
      const Color(0xFF0E0E0E),
    ],

    // Green / Yellow
    [
      const Color(0xFF65A30D),
      const Color(0xFF263D0B),
      const Color(0xFF0E0E0E),
    ],

    // Dark Lime
    [
      const Color(0xFF4D8C22),
      const Color(0xFF213B13),
      const Color(0xFF0E0E0E),
    ],

    // Purple Spotify-style
    [
      const Color(0xFF5B3A8E),
      const Color(0xFF291A42),
      const Color(0xFF0E0E0E),
    ],

    // Blue Purple
    [
      const Color(0xFF414E91),
      const Color(0xFF202749),
      const Color(0xFF0E0E0E),
    ],

    // Pink Purple
    [
      const Color(0xFF813F72),
      const Color(0xFF3A1D34),
      const Color(0xFF0E0E0E),
    ],
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    final random = Random();

    gradientColors = gradients[random.nextInt(gradients.length)];
    _initAudio();
  }

  Future<void> _initAudio() async {
    final audioUrl = widget.song.audioUrl ??
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      _audioPlayer.positionStream.listen((pos) {
        if (mounted) {
          setState(() {
            _position = pos;
          });
        }
      });

      _audioPlayer.durationStream.listen((dur) {
        if (mounted && dur != null) {
          setState(() {
            _duration = dur;
          });
        }
      });

      _audioPlayer.playerStateStream.listen((state) {
        if (mounted) {
          setState(() {
            isPlaying = state.playing;
            if (state.processingState == ProcessingState.ready ||
                state.processingState == ProcessingState.completed) {
              isLoading = false;
            }
          });
        }
      });

      await _audioPlayer.setSpeed(1.0);

      if (audioUrl.startsWith('http://') || audioUrl.startsWith('https://')) {
        await _audioPlayer.setUrl(audioUrl);
      } else {
        await _audioPlayer.setAsset(audioUrl);
      }
      await _audioPlayer.play();
    } catch (e) {
      debugPrint('Error playing audio: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Khởi tạo âm thanh thất bại';
        });
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString();
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Widget _buildArtwork() {
    final netUrl = widget.song.networkImageUrl;
    final imageWidth = MediaQuery.of(context).size.width * 0.8;

    if (netUrl != null && netUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: netUrl,
        width: imageWidth,
        height: imageWidth,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: imageWidth,
          height: imageWidth,
          color: Colors.white10,
          child: const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF00AFC4),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Image.asset(
          widget.song.imagePath,
          width: imageWidth,
          height: imageWidth,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: imageWidth,
            height: imageWidth,
            color: Colors.white10,
            child: const Icon(
              Icons.music_note,
              color: Colors.white54,
              size: 64,
            ),
          ),
        ),
      );
    }

    return Image.asset(
      widget.song.imagePath,
      width: imageWidth,
      height: imageWidth,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        width: imageWidth,
        height: imageWidth,
        color: Colors.white10,
        child: const Icon(
          Icons.music_note,
          color: Colors.white54,
          size: 64,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxSeconds = _duration.inSeconds.toDouble();
    final currentSeconds = _position.inSeconds.toDouble().clamp(
          0.0,
          maxSeconds > 0 ? maxSeconds : 1.0,
        );

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F10),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              gradientColors[0],
              gradientColors[0],
              gradientColors[1],
              gradientColors[2],
            ],
            stops: const [
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
              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Column(
                      children: [
                        const Text(
                          'PLAYING FROM PLAYLIST:',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              widget.playlistName,
                              style: const TextStyle(
                                color: Color(0xFF00AFC4),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xFF00AFC4),
                              size: 18,
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () {
                        showSongOptionsMenu(context, widget.song);
                      },
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // Song Artwork
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: _buildArtwork(),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Song Title, Artist & Actions
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.song.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.song.artist,
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 16,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.share_outlined,
                              color: Colors.white70,
                              size: 22,
                            ),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked
                                  ? const Color(0xFF00AFC4)
                                  : Colors.white70,
                              size: 22,
                            ),
                            onPressed: () {
                              setState(() {
                                isLiked = !isLiked;
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Progress Slider & Timers
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 3,
                          activeTrackColor: const Color(0xFF00AFC4),
                          inactiveTrackColor: Colors.white24,
                          thumbColor: const Color(0xFF00AFC4),
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 12,
                          ),
                        ),
                        child: Slider(
                          value: currentSeconds,
                          min: 0.0,
                          max: maxSeconds > 0 ? maxSeconds : 1.0,
                          onChanged: (value) {
                            _audioPlayer.seek(Duration(seconds: value.toInt()));
                          },
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(_position),
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              _formatDuration(_duration),
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Playback Controls Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isShuffle = !isShuffle;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isShuffle
                                    ? const Color(0x3300AFC4)
                                    : Colors.white10,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.shuffle,
                                color: isShuffle
                                    ? const Color(0xFF00AFC4)
                                    : Colors.white70,
                                size: 20,
                              ),
                            ),
                          ),

                          IconButton(
                            icon: const Icon(
                              Icons.skip_previous,
                              color: Colors.white,
                              size: 32,
                            ),
                            onPressed: () {},
                          ),

                          // Play/Pause Circle Button with AudioPlayer control
                          GestureDetector(
                            onTap: () async {
                              if (_audioPlayer.playing) {
                                await _audioPlayer.pause();
                              } else {
                                await _audioPlayer.play();
                              }
                            },
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF00AFC4),
                              ),
                              child: isLoading
                                  ? const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF0D0F10),
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : Icon(
                                      isPlaying ? Icons.pause : Icons.play_arrow,
                                      color: const Color(0xFF0D0F10),
                                      size: 36,
                                    ),
                            ),
                          ),

                          IconButton(
                            icon: const Icon(
                              Icons.skip_next,
                              color: Colors.white,
                              size: 32,
                            ),
                            onPressed: () {},
                          ),

                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isRepeat = !isRepeat;
                                _audioPlayer.setLoopMode(
                                  isRepeat ? LoopMode.one : LoopMode.off,
                                );
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isRepeat
                                    ? const Color(0x3300AFC4)
                                    : Colors.white10,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.sync_rounded,
                                color: isRepeat
                                    ? const Color(0xFF00AFC4)
                                    : Colors.white70,
                                size: 20,
                              ),
                            ),
                          ),

                          // IconButton(
                          //   icon: const Icon(
                          //     Icons.add,
                          //     color: Colors.white54,
                          //     size: 24,
                          //   ),
                          //   onPressed: () {},
                          // ),
                        ],
                      ),

                      if (errorMessage != null) ...[
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            errorMessage!,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),

                      // Download Button Icon
                      // Center(
                      //   child: IconButton(
                      //     icon: const Icon(
                      //       Icons.download_for_offline_outlined,
                      //       color: Colors.white54,
                      //       size: 24,
                      //     ),
                      //     onPressed: () {},
                      //   ),
                      // ),

                      const SizedBox(height: 24),

                      // LYRICS Section
                      Builder(
                        builder: (context) {
                          final lyricsLines = _getLyricsLines();
                          final displayedLines = isLyricsExpanded
                              ? lyricsLines
                              : lyricsLines.take(4).toList();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'LYRICS',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  if (lyricsLines.length > 4)
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isLyricsExpanded = !isLyricsExpanded;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white10,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              isLyricsExpanded
                                                  ? 'Show less'
                                                  : 'Show more',
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Icon(
                                              isLyricsExpanded
                                                  ? Icons.keyboard_arrow_up
                                                  : Icons.keyboard_arrow_down,
                                              color: Colors.white70,
                                              size: 16,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Lyrics Container Box
                              AnimatedSize(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 24,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xFF00AFC4),
                                        Color(0xFF044850),
                                        Color(0xFF091E21),
                                      ],
                                      stops: [0.0, 0.65, 1.0],
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ...displayedLines.map(
                                        (line) => Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10.0),
                                          child: Text(
                                            line,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              height: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (lyricsLines.length > 4) ...[
                                        const SizedBox(height: 12),
                                        Center(
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isLyricsExpanded =
                                                    !isLyricsExpanded;
                                              });
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 8,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.black26,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                mainAxisSize:
                                                    MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    isLyricsExpanded
                                                        ? 'Show less'
                                                        : 'Show more',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Icon(
                                                    isLyricsExpanded
                                                        ? Icons.keyboard_arrow_up
                                                        : Icons
                                                            .keyboard_arrow_down,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
