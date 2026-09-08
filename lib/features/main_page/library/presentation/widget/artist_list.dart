
import 'package:app_music/core/constant/app_assets.dart';
import 'package:flutter/material.dart';

class ArtistList extends StatelessWidget {
  const ArtistList({super.key});

  static const artists = [
    _Artist(
      name: 'Conan Gray',
      image: AppAssets.artistImage1,
    ),
    _Artist(
      name: 'Chase Atlantic',
      image: AppAssets.artistImage2,
    ),
    _Artist(
      name: 'New Jeans',
      image: AppAssets.artistImage3,
    ),
    _Artist(
      name: 'Keshi',
      image: AppAssets.artistImage4,
    ),
    _Artist(
      name: 'MCK',
      image: AppAssets.artistImage5,
    ),
    _Artist(
      name: 'LowG',
      image: AppAssets.artistImage6,
    ),
    _Artist(
      name: 'Sơn Tùng MTP',
      image: AppAssets.artistImage7,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        const SizedBox(height: 18),

        ...artists.map(
              (artist) => _ArtistItem(
            artist: artist,
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

class _ArtistItem extends StatelessWidget {
  final _Artist artist;
  final VoidCallback onTap;

  const _ArtistItem({
    required this.artist,
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
            ClipOval(
              child: Image.asset(
                artist.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Text(
                artist.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Artist {
  final String name;
  final String image;

  const _Artist({
    required this.name,
    required this.image,
  });
}