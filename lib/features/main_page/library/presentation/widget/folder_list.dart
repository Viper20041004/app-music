import 'package:app_music/features/main_page/library/data/folder_model.dart';
import 'package:app_music/features/main_page/library/presentation/widget/folder_row.dart';
import 'package:flutter/material.dart';

class FoldersList extends StatelessWidget {
  const FoldersList();

  static final folders = [
    FolderModel(
      name: 'moods',
      count: '11 playlists',
    ),
    FolderModel(
      name: 'blends',
      count: '8 playlists',
    ),
    FolderModel(
      name: 'favs',
      count: '14 playlists',
    ),
    FolderModel(
      name: 'random?',
      count: '10 playlists',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: folders.map((folder) {
        return FolderRow(
          folder: folder,
          onTap: () {
            debugPrint(
              'Selected folder: ${folder.name}',
            );
          },
        );
      }).toList(),
    );
  }
}