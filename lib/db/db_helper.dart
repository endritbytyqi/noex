import 'dart:io';
import 'package:noexis_task/data/models/favorite_place.dart';
import 'package:noexis_task/data/services/auth_service.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';

class DatabaseHelper {
  static const _databaseName = 'map_app.db';
  static const _databaseVersion = 2;

  static const table = 'favorite_place';

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnLatitude = 'latitude';
  static const columnLongitude = 'longitude';
  static const columnImageUrl = 'imageUrl';
  static const columnUserId = 'userId'; 

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnLatitude REAL NOT NULL,
        $columnLongitude REAL NOT NULL,
        $columnImageUrl TEXT,
        $columnUserId TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertFavoritePlace(FavoritePlace place, String userId) async {
    Database? db = await instance.database;
    place.userId = userId;
    return await db!.insert(table, place.toMap());
  }

  Future<List<FavoritePlace>> queryAllFavoritePlaces() async {
    Database? db = await instance.database;
    String userId =
        Get.find<AuthService>().currentUser!.uid; 
    List<Map<String, dynamic>> places = await db!.query(
      table,
      where: '$columnUserId = ?',
      whereArgs: [userId],
    );
    return places.map((place) => FavoritePlace.fromMap(place)).toList();
  }

  Future<int> removeFavoritePlace(int id) async {
    Database? db = await instance.database;
    return await db!.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateFavoritePlace(FavoritePlace place) async {
    Database? db = await instance.database;
    return await db!.update(
      table,
      place.toMap(),
      where: '$columnId = ?',
      whereArgs: [place.id],
    );
  }
}
