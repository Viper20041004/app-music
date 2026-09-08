
import 'package:app_music/core/constant/app_assets.dart';
import 'package:flutter/material.dart';

class AlbumsList extends StatelessWidget {
  const AlbumsList({super.key});

  static const albums = [
    Album(
      name: 'Superache',
      image: AppAssets.album1,
      nameArtist: 'Conan Gray',
    ),
    Album(
      name: 'Dawn FM',
      image: AppAssets.album2,
      nameArtist: 'The Weekend',
    ),
    Album(
      name: 'Hope',
      image: AppAssets.album3,
      nameArtist: 'Shiki',
    ),
    Album(
      name: 'Fire',
      image: AppAssets.album4,
      nameArtist: 'BTS',
    ),
    Album(
      name: '2730',
      image: AppAssets.album5,
      nameArtist: 'MCK',
    ),
    Album(
      name: 'GG',
      image: AppAssets.album6,
      nameArtist: 'LowG',
    ),
    Album(
      name: 'Album',
      image: AppAssets.album7,
      nameArtist: 'Sơn Tùng MTP',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        const SizedBox(height: 18),

        ...albums.map(
              (artist) => AlbumItem(
            album: artist,
            onTap: () {
              debugPrint(
                'Selected artist: ${artist.name}',
              );
            },
          ),
        ),
      ],
    );
  }
}

class AlbumItem extends StatelessWidget {
  final Album album;
  final VoidCallback onTap;

  const AlbumItem({
    required this.album,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            Image.asset(
              album.image,
              width: 80,
              height: 80,
            ),

            const SizedBox(width: 18),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  album.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  album.nameArtist,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Album {
  final String name;
  final String image;
  final String nameArtist;

  const Album({
    required this.name,
    required this.image,
    required this.nameArtist,
  });
}