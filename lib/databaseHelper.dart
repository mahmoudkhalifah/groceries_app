import 'package:groceries_list/grocery.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    return await openDatabase(
      "groceries",
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE groceries(
            id INTEGER PRIMARY KEY,
            name TEXT
          )
        ''');
      },
    );
  }

  Future<List<Grocery>> getGroceries() async {
    Database db = await instance.database;
    var groceries = await db.query('groceries');
    List<Grocery> groceriesList = groceries.isNotEmpty
      ? groceries.map((grocery) => Grocery.fromMap(grocery)).toList()
      : [];
    return groceriesList;
  }

  Future<int> add(Grocery grocery) async {
    Database db = await instance.database;
    return await db.insert('groceries', grocery.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return db.delete('groceries',where: 'id = ?',whereArgs: [id]);
  }

  Future<int> update(Grocery grocery) async {
    Database db = await instance.database;
    return await db.update('groceries', grocery.toMap(),where: 'id = ?',whereArgs: [grocery.id]);
  }
}