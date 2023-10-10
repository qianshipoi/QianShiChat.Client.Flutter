import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/utils/database.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<StatefulWidget> createState() => AddTodoPageState();
}

class AddTodoPageState extends State<AddTodoPage> {
  final _titleController = TextEditingController();
  var _isDone = false;

  _submit() async {
    DBProvider.db.addData(
        _titleController.text, DateTime.now().toString(), _isDone ? 1 : 0);
    Get.snackbar('通知', '插入完毕');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _titleController,
          ),
          Checkbox(
              value: _isDone,
              onChanged: (val) => {
                    setState(() {
                      _isDone = val!;
                    })
                  }),
          ElevatedButton(
            onPressed: () => {_submit()},
            child: const Text('Submit'),
          ),
          ElevatedButton(
              onPressed: () => {Navigator.pop(context)},
              child: const Text('Back'))
        ],
      ),
    );
  }
}
