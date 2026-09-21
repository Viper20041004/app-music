import 'package:app_music/core/database/database_helper.dart';
import 'package:app_music/features/auth/data/user_model.dart';
import 'package:app_music/features/main_page/library/data/playlist_model.dart';
import 'package:app_music/features/main_page/library/data/song_model.dart';

abstract class AppDatabaseService {
  // Songs
  Future<int> saveSong(SongModel song);
  Future<void> saveSongs(List<SongModel> songs);
  Future<List<SongModel>> getSongs();
  Future<List<SongModel>> searchSongs(String query);
  Future<void> setFavorite(int songId, bool isFavorite);
  Future<List<SongModel>> getFavorites();

  // Playlists
  Future<int> createPlaylist(PlaylistModel playlist);
  Future<List<PlaylistModel>> getPlaylists();
  Future<void> addSongToPlaylist(int playlistId, int songId);
  Future<void> removeSongFromPlaylist(int playlistId, int songId);
  Future<List<SongModel>> getPlaylistSongs(int playlistId);

  // History & Searches
  Future<void> recordPlayedSong(int songId);
  Future<List<SongModel>> getRecentHistory();
  Future<void> saveSearchQuery(String query);
  Future<List<String>> getRecentSearches();

  // User Profile
  Future<int> saveUser(UserModel user);
  Future<UserModel?> getUserByEmail(String email);
}

class AppDatabase implements AppDatabaseService {
  final DatabaseHelper _dbHelper;

  AppDatabase({DatabaseHelper? helper})
      : _dbHelper = helper ?? DatabaseHelper.instance;

  @override
  Future<int> saveSong(SongModel song) => _dbHelper.insertSong(song);

  @override
  Future<void> saveSongs(List<SongModel> songs) => _dbHelper.insertSongs(songs);

  @override
  Future<List<SongModel>> getSongs() => _dbHelper.getAllSongs();

  @override
  Future<List<SongModel>> searchSongs(String query) => _dbHelper.searchSongs(query);

  @override
  Future<void> setFavorite(int songId, bool isFavorite) =>
      _dbHelper.toggleFavoriteSong(songId, isFavorite);

  @override
  Future<List<SongModel>> getFavorites() => _dbHelper.getFavoriteSongs();

  @override
  Future<int> createPlaylist(PlaylistModel playlist) =>
      _dbHelper.createPlaylist(playlist);

  @override
  Future<List<PlaylistModel>> getPlaylists() => _dbHelper.getAllPlaylists();

  @override
  Future<void> addSongToPlaylist(int playlistId, int songId) =>
      _dbHelper.addSongToPlaylist(playlistId, songId);

  @override
  Future<void> removeSongFromPlaylist(int playlistId, int songId) =>
      _dbHelper.removeSongFromPlaylist(playlistId, songId);

  @override
  Future<List<SongModel>> getPlaylistSongs(int playlistId) =>
      _dbHelper.getSongsInPlaylist(playlistId);

  @override
  Future<void> recordPlayedSong(int songId) => _dbHelper.addToHistory(songId);

  @override
  Future<List<SongModel>> getRecentHistory() =>
      _dbHelper.getRecentlyPlayedSongs();

  @override
  Future<void> saveSearchQuery(String query) =>
      _dbHelper.addSearchQuery(query);

  @override
  Future<List<String>> getRecentSearches() => _dbHelper.getRecentSearches();

  @override
  Future<int> saveUser(UserModel user) => _dbHelper.insertUser(user);

  @override
  Future<UserModel?> getUserByEmail(String email) =>
      _dbHelper.getUserByEmail(email);
}
