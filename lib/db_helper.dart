import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:shopping_cart/model/model.dart';
import 'package:path/path.dart ';

class DbHelper {
  static Database? _db;

  Future<Database?> db() async {
    if (_db != null) {
      return _db!;
    }

    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'shopping_cart.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE cart (id INTEGER PRIMARY KEY , productId VARCHAR UNIQUE,productName TEXT,initialPrice INTEGER, productPrice INTEGER , quantity INTEGER, unitTag TEXT , image TEXT )');
  }

  Future<Cart> insert(Cart cart) async {
    var dbClient = await db();
    if (dbClient == null) {
      throw Exception('Database connection failed');
    }
    await dbClient.insert('cart', cart.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return cart;
  }

  Future<List<Cart>> getCartList() async {
    var dbClient = await db();

    final List<Map<String, Object?>> querryResult =
        await dbClient!.query('cart');
    return querryResult.map((e) => Cart.fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    var dbClient = await db();
    return dbClient!.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updtadeQuantity(Cart cart) async {
    var dbClient = await db();
    return dbClient!
        .update('cart', cart.toMap(), where: 'id = ?', whereArgs: [cart.id]);
  }
}
