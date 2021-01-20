import 'package:flutter_movies/models/models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String _favTable = 'favTable';
  String _title = 'title';
  String _year = 'year';
  String _imdbID = 'imdbID';
  String _type = 'type';
  String _poster = 'poster';

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._internal();
      return _databaseHelper;
    } else {
      return _databaseHelper;
    }
  }

  DatabaseHelper._internal();

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  Future<Database> _initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "appDB.db");
    print("The path of the created Db : $path");
    var favDB = await openDatabase(path, version: 1, onCreate: _createDB);
    return favDB;
  }

  Future _createDB(Database db, int version) async {
    print("CREATE DB METHOD IS WORKED,TABLE GOING TO CREATE");
    await db.execute(
        "CREATE TABLE $_favTable ($_title TEXT, $_year TEXT, $_imdbID TEXT, $_type TEXT, $_poster TEXT)");
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    var db = await _getDatabase();
    var result = await db.query(_favTable);
    return result;
  }

  Future<List<Favorite>> getFavoriteList() async {
    var favMapList = await getFavorites();
    var favList = List<Favorite>();
    for (Map map in favMapList) {
      favList.add(Favorite.fromMap(map));
    }
    return favList;
  }

  Future<int> addFavorite(Movie movie) async {
    Favorite fav = Favorite();
    fav.title = movie.title;
    fav.year = movie.year;
    fav.imdbID = movie.imdbID;
    fav.type = movie.type;
    fav.poster = movie.poster;

    var db = await _getDatabase();
    var result = await db.insert(_favTable, fav.toMap());
    return result;
  }

  Future<int> removeFavorite(Movie movie) async {
    var db = await _getDatabase();
    var result = await db
        .delete(_favTable, where: 'imdbID = ?', whereArgs: [movie.imdbID]);
    return result;
  }
}
