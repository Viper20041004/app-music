import 'package:app_music/core/navigation/app_navigator.dart';
import 'package:app_music/features/main_page/library/data/folder_model.dart';
import 'package:app_music/features/main_page/library/presentation/page/folder_detail_screen.dart';
import 'package:app_music/features/main_page/library/presentation/widget/folder_row.dart';
import 'package:flutter/material.dart';

class FoldersList extends StatelessWidget {
  const FoldersList();

  static final folders = [
    FolderModel(
      name: 'Moods',
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
            AppNavigator.push(
              context,
              FolderDetailScreen(folder: folder),
            );
          },
        );
      }).toList(),
    );
  }
}