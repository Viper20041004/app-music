import 'package:app_music/app/app.dart';
import 'package:app_music/core/storage/local_song_storage.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalSongStorage.instance.init();
  runApp(const MusicApp());
}