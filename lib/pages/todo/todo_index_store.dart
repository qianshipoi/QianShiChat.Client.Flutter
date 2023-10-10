import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:qianshi_chat/models/todo.dart';
import 'package:sqflite/sqflite.dart';

class TodoIndexStore extends ChangeNotifier {
  var dbNmme = 'mydb.db';
  var tbName = 'todo';

  List<Todo> todos = [];

  Future<Database> _getDb() async {
    WidgetsFlutterBinding.ensureInitialized();
    return await openDatabase(join(await getDatabasesPath(), dbNmme));
  }

  Future createTable() async {
    var db = await _getDb();
    db.execute("""
      create table if not exists $tbName(
        id integer primary key autoincrement,
        title text not null,
        create_time text not null,
        is_done integer not null
      )
    """);
  }

  Future addData(String title, String createTime, int isDone) async {
    var db = await _getDb();
    var id = await db.insert(
        tbName, {'title': title, 'create_time': createTime, 'is_done': isDone});
    todos.add(
        Todo(id: id, title: title, createTime: createTime, isDone: isDone));
    notifyListeners();
  }

  Future deleteData(int id) async {
    var db = await _getDb();
    await db.delete(tbName, where: 'id = ?', whereArgs: [id]);
    todos.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Future doneData(int id) async {
    var db = await _getDb();
    await db.update(tbName, {'is_done': 1}, where: 'id = ?', whereArgs: [id]);
    todos = todos.map((e) {
      if (e.id == id) {
        return e.copyWith(isDone: 1);
      }
      return e;
    }).toList();
    notifyListeners();
  }

  Future undoneData(int id) async {
    var db = await _getDb();
    await db.update(tbName, {'is_done': 0}, where: 'id = ?', whereArgs: [id]);
    todos = todos.map((e) {
      if (e.id == id) {
        return e.copyWith(isDone: 0);
      }
      return e;
    }).toList();
    notifyListeners();
  }

  Future queryData() async {
    var db = await _getDb();
    var res = await db.query(tbName);
    todos = res.map((e) => Todo.fromMap(e)).toList();
    notifyListeners();
  }
}
