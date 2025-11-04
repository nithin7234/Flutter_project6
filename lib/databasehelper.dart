import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'product.dart';


class DatabaseHelper {
  static Database? _database;
  static DatabaseHelper instance = DatabaseHelper._privateConstructor();
  DatabaseHelper._privateConstructor();
  Future<Database> get database async{
    if(_database!=null) return _database!;
    Directory dir= await getApplicationDocumentsDirectory();
    String path=join(dir.path,"products.db");
    _database=await openDatabase(
      path,
      version: 1,
      onCreate: (db,version) async{
        String sql="CREATE TABLE products(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,quantity INTEGER,price REAL)";
        await db.execute(sql);
      },  );
      return _database!;  }
  Future<int> insertProduct(Product product) async{ Database db=await instance.database; return await db.insert('products',{'name':product.name,'quantity':product.quantity,'price':product.price});
  }
  Future<List<Product>> readAllProducts() async{
    Database db=await instance.database;
    final records=await db.query("products");
    return records.map((record)=>Product.fromRow(record)).toList();
    }
  Future<int> resetProducts() async {
  final db = await instance.database;
  return await db.delete("products");
}}
