import 'dart:convert';
import 'dart:io';
import 'package:app_music/features/main_page/library/data/song_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalSongStorage {
  static final LocalSongStorage instance = LocalSongStorage._internal();
  LocalSongStorage._internal();

  static const String _storageKey = 'downloaded_songs_list';
  final ValueNotifier<List<SongModel>> downloadedSongsNotifier =
      ValueNotifier<List<SongModel>>([]);
  bool _isInitialized = false;

  /// Khởi tạo và nạp danh sách bài hát từ localStorage
  Future<void> init() async {
    if (_isInitialized) return;
    await getDownloadedSongs();
    _isInitialized = true;
  }

  /// Lấy danh sách bài hát đã lưu trong localStorage (SharedPreferences)
  Future<List<SongModel>> getDownloadedSongs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonString);
        final list = decoded
            .map((e) => SongModel.fromMap(Map<String, dynamic>.from(e)))
            .toList();
        downloadedSongsNotifier.value = list;
        return list;
      }
    } catch (e) {
      debugPrint('LocalSongStorage: Error reading songs: $e');
    }
    downloadedSongsNotifier.value = [];
    return [];
  }

  /// Kiểm tra bài hát đã được tải về hay chưa
  bool isDownloaded(SongModel song) {
    return downloadedSongsNotifier.value.any((s) => s.matches(song));
  }

  /// Lưu bài hát vào localStorage (SharedPreferences)
  Future<bool> saveSong(SongModel song) async {
    try {
      final currentList = List<SongModel>.from(downloadedSongsNotifier.value);
      final index = currentList.indexWhere((s) => s.matches(song));
      if (index >= 0) {
        currentList[index] = song;
      } else {
        currentList.insert(0, song);
      }

      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(currentList.map((s) => s.toMap()).toList());
      await prefs.setString(_storageKey, encoded);

      downloadedSongsNotifier.value = currentList;
      return true;
    } catch (e) {
      debugPrint('LocalSongStorage: Error saving song: $e');
      return false;
    }
  }

  /// Tải file bài hát và lưu metadata vào localStorage
  Future<bool> downloadSong(
    SongModel song, {
    void Function(int received, int total)? onProgress,
  }) async {
    try {
      String? savedFilePath = song.localFilePath;

      // Nếu bài hát có audioUrl online, tải file về máy
      final audioUrl = song.audioUrl;
      if (audioUrl != null &&
          (audioUrl.startsWith('http://') || audioUrl.startsWith('https://'))) {
        try {
          final dir = await getApplicationDocumentsDirectory();
          final downloadDir = Directory('${dir.path}/downloaded_songs');
          if (!await downloadDir.exists()) {
            await downloadDir.create(recursive: true);
          }

          final safeTitle = song.title.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
          final fileName =
              '${song.id ?? song.serverId ?? safeTitle.hashCode}_$safeTitle.mp3';
          final filePath = '${downloadDir.path}/$fileName';

          final dio = Dio();
          await dio.download(
            audioUrl,
            filePath,
            onReceiveProgress: onProgress,
          );

          savedFilePath = filePath;
        } catch (downloadErr) {
          debugPrint('LocalSongStorage: Audio file download error: $downloadErr');
        }
      }

      final updatedSong = song.copyWith(
        localFilePath: savedFilePath,
      );

      return await saveSong(updatedSong);
    } catch (e) {
      debugPrint('LocalSongStorage: Error downloading song: $e');
      // Vẫn lưu thông tin bài hát vào localStorage dù tải file âm thanh gặp lỗi
      await saveSong(song);
      return false;
    }
  }

  /// Xóa bài hát khỏi danh sách tải về trong localStorage và xóa file âm thanh nội bộ
  Future<bool> removeSong(SongModel song) async {
    try {
      final currentList = List<SongModel>.from(downloadedSongsNotifier.value);
      final item = currentList.firstWhere(
        (s) => s.matches(song),
        orElse: () => song,
      );

      if (item.localFilePath != null) {
        try {
          final file = File(item.localFilePath!);
          if (await file.exists()) {
            await file.delete();
          }
        } catch (fileErr) {
          debugPrint('LocalSongStorage: Error deleting local file: $fileErr');
        }
      }

      currentList.removeWhere((s) => s.matches(song));

      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(currentList.map((s) => s.toMap()).toList());
      await prefs.setString(_storageKey, encoded);

      downloadedSongsNotifier.value = currentList;
      return true;
    } catch (e) {
      debugPrint('LocalSongStorage: Error removing song: $e');
      return false;
    }
  }
}
