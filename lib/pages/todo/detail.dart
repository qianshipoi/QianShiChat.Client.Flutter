// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:qianshi_chat/models/todo.dart';

class TodoDetailPage extends StatefulWidget {
  const TodoDetailPage({
    Key? key,
    required this.todo,
  }) : super(key: key);

  final Todo todo;

  @override
  State<StatefulWidget> createState() => _TodoDetailPageState();
}

class _TodoDetailPageState extends State<TodoDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(widget.todo.title),
    );
  }
}
