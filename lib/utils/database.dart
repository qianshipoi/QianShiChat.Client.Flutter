import 'dart:io';

import 'package:path/path.dart';
import 'package:qianshi_chat/models/todo.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  var dbNmme = 'mydb1.db';
  var tbName = 'todo';

  initDB() async {
    sqfliteFfiInit();
    if (Platform.isWindows) {
      databaseFactory = databaseFactoryFfi;
    }

    return await openDatabase(join(await getDatabasesPath(), dbNmme),
        version: 1,
        onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db.execute("""
        create table if not exists $tbName(
          id integer primary key autoincrement,
        title text not null,
          create_time text not null,
          is_done integer not null
        )
      """);
    });
  }

  Future<int> addData(String title, String createTime, int isDone) async {
    final db = await database;
    var id = await db.insert(
        tbName, {'title': title, 'create_time': createTime, 'is_done': isDone});
    return id;
  }

  Future deleteData(int id) async {
    var db = await database;
    await db.delete(tbName, where: 'id = ?', whereArgs: [id]);
  }

  Future doneData(int id) async {
    var db = await database;
    await db.update(tbName, {'is_done': 1}, where: 'id = ?', whereArgs: [id]);
  }

  Future undoneData(int id) async {
    var db = await database;
    await db.update(tbName, {'is_done': 0}, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Todo>> queryData() async {
    final db = await database;
    var res = await db.query(tbName);
    return res.map((e) => Todo.fromMap(e)).toList();
  }
}
