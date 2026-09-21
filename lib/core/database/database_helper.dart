import 'package:app_music/features/auth/data/user_model.dart';
import 'package:app_music/features/main_page/library/data/playlist_model.dart';
import 'package:app_music/features/main_page/library/data/song_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'musium_music.db');

    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 1. Users Table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE NOT NULL,
        username TEXT,
        avatar_url TEXT,
        created_at TEXT
      )
    ''');

    // 2. Songs Table
    await db.execute('''
      CREATE TABLE songs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        server_id TEXT,
        title TEXT NOT NULL,
        artist TEXT NOT NULL,
        album TEXT,
        image_path TEXT,
        network_image_url TEXT,
        audio_url TEXT,
        lyrics TEXT,
        duration INTEGER,
        is_favorite INTEGER DEFAULT 0,
        created_at TEXT
      )
    ''');

    // 3. Playlists Table
    await db.execute('''
      CREATE TABLE playlists (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        image_path TEXT,
        song_count INTEGER DEFAULT 0,
        created_at TEXT
      )
    ''');

    // 4. Playlist Songs Junction Table
    await db.execute('''
      CREATE TABLE playlist_songs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        playlist_id INTEGER NOT NULL,
        song_id INTEGER NOT NULL,
        position INTEGER,
        added_at TEXT,
        FOREIGN KEY (playlist_id) REFERENCES playlists (id) ON DELETE CASCADE,
        FOREIGN KEY (song_id) REFERENCES songs (id) ON DELETE CASCADE
      )
    ''');

    // 5. Favorites Table
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        song_id INTEGER UNIQUE NOT NULL,
        created_at TEXT,
        FOREIGN KEY (song_id) REFERENCES songs (id) ON DELETE CASCADE
      )
    ''');

    // 6. Listening History Table
    await db.execute('''
      CREATE TABLE listening_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        song_id INTEGER NOT NULL,
        played_at TEXT,
        FOREIGN KEY (song_id) REFERENCES songs (id) ON DELETE CASCADE
      )
    ''');

    // 7. Search History Table
    await db.execute('''
      CREATE TABLE search_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        query TEXT NOT NULL,
        searched_at TEXT
      )
    ''');

    // Indexes for fast lookup
    await db.execute('CREATE INDEX idx_songs_title ON songs(title);');
    await db.execute('CREATE INDEX idx_songs_artist ON songs(artist);');
    await db.execute('CREATE INDEX idx_playlist_songs_playlist ON playlist_songs(playlist_id);');
    await db.execute('CREATE INDEX idx_history_played_at ON listening_history(played_at);');
  }

  // ==========================================
  // SONGS CRUD OPERATIONS
  // ==========================================

  Future<int> insertSong(SongModel song) async {
    final db = await database;
    return await db.insert(
      'songs',
      song.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertSongs(List<SongModel> songs) async {
    final db = await database;
    final batch = db.batch();
    for (final song in songs) {
      batch.insert(
        'songs',
        song.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<SongModel>> getAllSongs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'songs',
      orderBy: 'id DESC',
    );
    return maps.map((m) => SongModel.fromMap(m)).toList();
  }

  Future<SongModel?> getSongById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'songs',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return SongModel.fromMap(maps.first);
    }
    return null;
  }

  Future<List<SongModel>> searchSongs(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'songs',
      where: 'title LIKE ? OR artist LIKE ? OR album LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );
    return maps.map((m) => SongModel.fromMap(m)).toList();
  }

  Future<int> updateSong(SongModel song) async {
    final db = await database;
    return await db.update(
      'songs',
      song.toMap(),
      where: 'id = ?',
      whereArgs: [song.id],
    );
  }

  Future<int> deleteSong(int id) async {
    final db = await database;
    return await db.delete(
      'songs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> toggleFavoriteSong(int songId, bool isFavorite) async {
    final db = await database;
    final isFavInt = isFavorite ? 1 : 0;

    await db.update(
      'songs',
      {'is_favorite': isFavInt},
      where: 'id = ?',
      whereArgs: [songId],
    );

    if (isFavorite) {
      await db.insert(
        'favorites',
        {
          'song_id': songId,
          'created_at': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      await db.delete(
        'favorites',
        where: 'song_id = ?',
        whereArgs: [songId],
      );
    }
  }

  Future<List<SongModel>> getFavoriteSongs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT s.* FROM songs s
      INNER JOIN favorites f ON s.id = f.song_id
      ORDER BY f.created_at DESC
    ''');
    return maps.map((m) => SongModel.fromMap(m)).toList();
  }

  // ==========================================
  // PLAYLISTS CRUD OPERATIONS
  // ==========================================

  Future<int> createPlaylist(PlaylistModel playlist) async {
    final db = await database;
    return await db.insert('playlists', playlist.toMap());
  }

  Future<List<PlaylistModel>> getAllPlaylists() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT p.*, COUNT(ps.id) AS song_count
      FROM playlists p
      LEFT JOIN playlist_songs ps ON p.id = ps.playlist_id
      GROUP BY p.id
      ORDER BY p.id DESC
    ''');

    return maps.map((m) {
      return PlaylistModel(
        id: m['id'] as int?,
        title: m['title'] as String? ?? 'Untitled',
        songCount: '${m['song_count'] ?? 0} songs',
        imagePath: m['image_path'] as String? ?? '',
        description: m['description'] as String?,
        createdAt: m['created_at'] as String?,
      );
    }).toList();
  }

  Future<PlaylistModel?> getPlaylistById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'playlists',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return PlaylistModel.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updatePlaylist(PlaylistModel playlist) async {
    final db = await database;
    return await db.update(
      'playlists',
      playlist.toMap(),
      where: 'id = ?',
      whereArgs: [playlist.id],
    );
  }

  Future<int> deletePlaylist(int playlistId) async {
    final db = await database;
    return await db.delete(
      'playlists',
      where: 'id = ?',
      whereArgs: [playlistId],
    );
  }

  Future<int> addSongToPlaylist(int playlistId, int songId) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    return await db.insert('playlist_songs', {
      'playlist_id': playlistId,
      'song_id': songId,
      'added_at': now,
    });
  }

  Future<int> removeSongFromPlaylist(int playlistId, int songId) async {
    final db = await database;
    return await db.delete(
      'playlist_songs',
      where: 'playlist_id = ? AND song_id = ?',
      whereArgs: [playlistId, songId],
    );
  }

  Future<List<SongModel>> getSongsInPlaylist(int playlistId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT s.* FROM songs s
      INNER JOIN playlist_songs ps ON s.id = ps.song_id
      WHERE ps.playlist_id = ?
      ORDER BY ps.id ASC
    ''', [playlistId]);
    return maps.map((m) => SongModel.fromMap(m)).toList();
  }

  // ==========================================
  // LISTENING HISTORY CRUD OPERATIONS
  // ==========================================

  Future<int> addToHistory(int songId) async {
    final db = await database;
    return await db.insert('listening_history', {
      'song_id': songId,
      'played_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<SongModel>> getRecentlyPlayedSongs({int limit = 20}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT s.*, MAX(h.played_at) as last_played
      FROM songs s
      INNER JOIN listening_history h ON s.id = h.song_id
      GROUP BY s.id
      ORDER BY last_played DESC
      LIMIT ?
    ''', [limit]);
    return maps.map((m) => SongModel.fromMap(m)).toList();
  }

  Future<int> clearHistory() async {
    final db = await database;
    return await db.delete('listening_history');
  }

  // ==========================================
  // SEARCH HISTORY CRUD OPERATIONS
  // ==========================================

  Future<int> addSearchQuery(String query) async {
    final db = await database;
    if (query.trim().isEmpty) return 0;
    return await db.insert('search_history', {
      'query': query.trim(),
      'searched_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<String>> getRecentSearches({int limit = 10}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'search_history',
      columns: ['query'],
      orderBy: 'id DESC',
      limit: limit,
    );
    return maps.map((m) => m['query'] as String).toList();
  }

  Future<int> clearSearchHistory() async {
    final db = await database;
    return await db.delete('search_history');
  }

  // ==========================================
  // USER CRUD OPERATIONS
  // ==========================================

  Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateUser(UserModel user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }
}