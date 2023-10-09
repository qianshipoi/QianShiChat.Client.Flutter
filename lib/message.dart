import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<StatefulWidget> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  var db_nmme = 'mydb.db';
  var tb_name = 'message';
  Future<Database> _getDb() async {
    return await openDatabase(join(await getDatabasesPath(), db_nmme));
  }

  void _createTable() async {
    var db = await _getDb();
    db.execute("""
      create table if not exists $tb_name(
        id integer primary key autoincrement,
        content text not null,
        time text not null
      )
    """);
  }

  void addData(String content, String time) async {
    var db = await _getDb();
    db.insert(tb_name, {'content': content, 'time': time});
  }

  void deleteData(int id) async {
    var db = await _getDb();
    db.delete(tb_name, where: 'id = ?', whereArgs: [id]);
  }

  void updateData(int id, String content, String time) async {
    var db = await _getDb();
    db.update(tb_name, {'content': content, 'time': time},
        where: 'id = ?', whereArgs: [id]);
  }

  void queryData() async {
    var db = await _getDb();
    var res = await db.query(tb_name);
    print(res);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {
              _createTable();
            },
            child: const Text('创建表')),
        ElevatedButton(
            onPressed: () {
              addData('hello', '2021-10-10');
            },
            child: const Text('插入数据')),
        ElevatedButton(
            onPressed: () {
              queryData();
            },
            child: const Text('获取数据')),
      ],
    ));
  }
}
