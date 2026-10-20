import 'package:app_music/core/storage/local_song_storage.dart';
import 'package:app_music/features/main_page/library/data/song_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('LocalSongStorage saves, loads and removes songs correctly', () async {
    final storage = LocalSongStorage.instance;
    await storage.init();

    expect(storage.downloadedSongsNotifier.value.isEmpty, true);

    const song = SongModel(
      id: 1,
      title: 'Em Của Ngày Hôm Qua',
      artist: 'Sơn Tùng M-TP',
      imagePath: 'assets/images/sample.png',
      audioUrl: 'https://example.com/audio.mp3',
    );

    // Save song
    final saved = await storage.saveSong(song);
    expect(saved, true);
    expect(storage.isDownloaded(song), true);
    expect(storage.downloadedSongsNotifier.value.length, 1);
    expect(storage.downloadedSongsNotifier.value.first.title, 'Em Của Ngày Hôm Qua');

    // Reload from storage
    final loaded = await storage.getDownloadedSongs();
    expect(loaded.length, 1);
    expect(loaded.first.title, 'Em Của Ngày Hôm Qua');

    // Remove song
    final removed = await storage.removeSong(song);
    expect(removed, true);
    expect(storage.isDownloaded(song), false);
    expect(storage.downloadedSongsNotifier.value.isEmpty, true);
  });
}
