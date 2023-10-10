import 'package:flutter/material.dart';
import 'package:qianshi_chat/models/todo.dart';
import 'package:qianshi_chat/pages/todo/add_todo.dart';
import 'package:qianshi_chat/pages/todo/detail.dart';
import 'package:qianshi_chat/utils/database.dart';

class TodoIndex extends StatefulWidget {
  const TodoIndex({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TodoIndexState();
}

class _TodoIndexState extends State<TodoIndex> {
  late Future<List<Todo>> _future;

  @override
  void initState() {
    super.initState();
    _future = fetchCardInfo();
  }

  //刷新数据
  Future refresh() async {
    setState(() {
      _future = fetchCardInfo();
    });
  }

  Future<List<Todo>> fetchCardInfo() async {
    return await DBProvider.db.queryData();
  }

  FutureBuilder<List<Todo>> buildFutureBuilder() {
    return FutureBuilder<List<Todo>>(
      builder: (context, AsyncSnapshot<List<Todo>> async) {
        if (async.connectionState == ConnectionState.active ||
            async.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (async.connectionState == ConnectionState.done) {
          if (async.hasError) {
            return const Center(
              child: Text("ERROR"),
            );
          } else if (async.hasData) {
            return RefreshIndicator(
                onRefresh: refresh, child: buildListView(context, async.data!));
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      future: _future,
    );
  }

  ListView buildListView(BuildContext context, List<Todo> todos) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(todos[index].title),
          subtitle: Text(todos[index].createTime),
          trailing: IconButton(
            onPressed: () {
              DBProvider.db.deleteData(todos[index].id);
              refresh();
            },
            icon: const Icon(Icons.delete),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TodoDetailPage(todo: todos[index]),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Todo'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddTodoPage()),
                );
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: buildFutureBuilder());
  }
}
