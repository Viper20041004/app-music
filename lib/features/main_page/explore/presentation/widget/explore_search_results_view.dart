import 'package:app_music/core/constant/app_assets.dart';
import 'package:app_music/core/navigation/app_navigator.dart';
import 'package:app_music/features/main_page/explore/data/explore_models.dart';
import 'package:app_music/features/main_page/library/data/song_model.dart';
import 'package:app_music/features/player/presentation/page/now_playing_screen.dart';
import 'package:app_music/features/player/presentation/widget/song_options_bottom_sheet.dart';
import 'package:app_music/features/main_page/explore/presentation/page/artist_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ExploreSearchResultsView extends StatelessWidget {
  final ExploreSearchResult result;
  final ExploreSearchFilter selectedFilter;
  final String query;
  final ValueChanged<ExploreSearchFilter> onFilterChange;
  final ValueChanged<String>? onSelectKeyword;

  const ExploreSearchResultsView({
    super.key,
    required this.result,
    required this.selectedFilter,
    required this.query,
    required this.onFilterChange,
    this.onSelectKeyword,
  });

  @override
  Widget build(BuildContext context) {
    if (result.isEmpty) {
      return _buildEmptyState();
    }

    switch (selectedFilter) {
      case ExploreSearchFilter.all:
        return _buildAllView(context);
      case ExploreSearchFilter.song:
        return _buildSongsView(context);
      case ExploreSearchFilter.artist:
        return _buildArtistsView(context);
      case ExploreSearchFilter.album:
        return _buildAlbumsView(context);
    }
  }

  // --- EMPTY STATE ---
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 42,
                color: Colors.white54,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No results found for "$query"',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Please check your spelling or search for another song, artist or album.',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // --- ALL VIEW ---
  Widget _buildAllView(BuildContext context) {
    final hasSongs = result.songs.isNotEmpty;
    final hasArtists = result.artists.isNotEmpty;
    final hasAlbums = result.albums.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasSongs) ...[
          _buildSectionHeader(
            title: 'Songs',
            count: result.songs.length,
            onSeeAll: () => onFilterChange(ExploreSearchFilter.song),
          ),
          const SizedBox(height: 10),
          ...result.songs
              .take(4)
              .map((song) => _buildSongTile(context, song)),
          const SizedBox(height: 20),
        ],
        if (hasArtists) ...[
          _buildSectionHeader(
            title: 'Artists',
            count: result.artists.length,
            onSeeAll: () => onFilterChange(ExploreSearchFilter.artist),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: result.artists.length,
              separatorBuilder: (context, index) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                return _buildArtistCard(context, result.artists[index]);
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
        if (hasAlbums) ...[
          _buildSectionHeader(
            title: 'Albums',
            count: result.albums.length,
            onSeeAll: () => onFilterChange(ExploreSearchFilter.album),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: result.albums.length,
              separatorBuilder: (context, index) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                return _buildAlbumCard(result.albums[index]);
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ],
    );
  }

  // --- SONGS VIEW ---
  Widget _buildSongsView(BuildContext context) {
    if (result.songs.isEmpty) {
      return _buildCategoryEmptyState('songs');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'Songs (${result.songs.length})',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: result.songs.length,
          separatorBuilder: (context, index) => const SizedBox(height: 4),
          itemBuilder: (context, index) {
            return _buildSongTile(context, result.songs[index]);
          },
        ),
      ],
    );
  }

  // --- ARTISTS VIEW ---
  Widget _buildArtistsView(BuildContext context) {
    if (result.artists.isEmpty) {
      return _buildCategoryEmptyState('artists');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'Artists (${result.artists.length})',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: result.artists.length,
          separatorBuilder: (context, index) => const Divider(
            color: Colors.white12,
            height: 14,
          ),
          itemBuilder: (context, index) {
            final artist = result.artists[index];
            return _buildArtistListTile(context, artist);
          },
        ),
      ],
    );
  }

  // --- ALBUMS VIEW ---
  Widget _buildAlbumsView(BuildContext context) {
    if (result.albums.isEmpty) {
      return _buildCategoryEmptyState('albums');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'Albums (${result.albums.length})',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: result.albums.length,
          separatorBuilder: (context, index) => const Divider(
            color: Colors.white12,
            height: 14,
          ),
          itemBuilder: (context, index) {
            final album = result.albums[index];
            return _buildAlbumListTile(album);
          },
        ),
      ],
    );
  }

  Widget _buildCategoryEmptyState(String category) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const Icon(Icons.info_outline, size: 36, color: Colors.white38),
            const SizedBox(height: 12),
            Text(
              'No $category found for "$query"',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  // --- REUSABLE COMPONENTS ---

  Widget _buildSectionHeader({
    required String title,
    required int count,
    required VoidCallback onSeeAll,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$title ($count)',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        GestureDetector(
          onTap: onSeeAll,
          child: const Text(
            'See all',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF00AFC4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSongTile(BuildContext context, SongModel song) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: _buildArtwork(song),
        ),
        title: Text(
          song.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${song.artist}${song.album != null && song.album!.isNotEmpty ? ' • ${song.album}' : ''}',
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white54,
                size: 20,
              ),
              onPressed: () {
                showSongOptionsMenu(context, song);
              },
            ),
          ],
        ),
        onTap: () {
          AppNavigator.push(
            context,
            NowPlayingScreen(
              song: song,
              playlistName: 'Search: $query',
            ),
          );
        },
      ),
    );
  }

  Widget _buildArtwork(SongModel song) {
    const size = 52.0;
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
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF00AFC4),
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) => _buildFallbackArtwork(song, size),
      );
    }
    return _buildFallbackArtwork(song, size);
  }

  Widget _buildFallbackArtwork(SongModel song, double size) {
    return Image.asset(
      song.imagePath.isNotEmpty ? song.imagePath : AppAssets.genImage1,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        width: size,
        height: size,
        color: const Color(0xFF1E2629),
        child: const Icon(
          Icons.music_note,
          color: Color(0xFF00AFC4),
          size: 24,
        ),
      ),
    );
  }

  void _openArtistDetail(BuildContext context, ExploreArtist artist) {
    AppNavigator.push(
      context,
      ArtistDetailScreen(
        artist: artist,
        name: artist.name,
        avatarUrl: artist.imageUrl,
        bannerUrl: artist.imageUrl,
      ),
    );
  }

  Widget _buildArtistCard(BuildContext context, ExploreArtist artist) {
    return GestureDetector(
      onTap: () => _openArtistDetail(context, artist),
      child: SizedBox(
        width: 80,
        child: Column(
          children: [
            ClipOval(
              child: _buildArtistAvatar(artist, size: 70),
            ),
            const SizedBox(height: 6),
            Text(
              artist.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArtistListTile(BuildContext context, ExploreArtist artist) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      leading: ClipOval(
        child: _buildArtistAvatar(artist, size: 52),
      ),
      title: Text(
        artist.name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        artist.description != null && artist.description!.isNotEmpty
            ? artist.description!
            : 'Artist',
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 12,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.white38,
        size: 20,
      ),
      onTap: () => _openArtistDetail(context, artist),
    );
  }

  Widget _buildArtistAvatar(ExploreArtist artist, {required double size}) {
    if (artist.imageUrl != null && artist.imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: artist.imageUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: size,
          height: size,
          color: Colors.white10,
        ),
        errorWidget: (context, url, error) => Container(
          width: size,
          height: size,
          color: const Color(0xFF1E2629),
          child: const Icon(Icons.person, color: Colors.white54),
        ),
      );
    }
    return Container(
      width: size,
      height: size,
      color: const Color(0xFF1E2629),
      child: const Icon(Icons.person, color: Colors.white54),
    );
  }

  Widget _buildAlbumCard(ExploreAlbum album) {
    return GestureDetector(
      onTap: () => onSelectKeyword?.call(album.title),
      child: SizedBox(
        width: 90,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _buildAlbumCover(album, size: 90),
            ),
            const SizedBox(height: 6),
            Text(
              album.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Text(
              'Album',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlbumListTile(ExploreAlbum album) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _buildAlbumCover(album, size: 52),
      ),
      title: Text(
        album.title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        album.releaseDate != null ? 'Album • ${album.releaseDate}' : 'Album',
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 12,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.white38,
        size: 20,
      ),
      onTap: () => onSelectKeyword?.call(album.title),
    );
  }

  Widget _buildAlbumCover(ExploreAlbum album, {required double size}) {
    if (album.imageUrl != null && album.imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: album.imageUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: size,
          height: size,
          color: Colors.white10,
        ),
        errorWidget: (context, url, error) => Container(
          width: size,
          height: size,
          color: const Color(0xFF1E2629),
          child: const Icon(Icons.album, color: Colors.white54),
        ),
      );
    }
    return Container(
      width: size,
      height: size,
      color: const Color(0xFF1E2629),
      child: const Icon(Icons.album, color: Colors.white54),
    );
  }
}
