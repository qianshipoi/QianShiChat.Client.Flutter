import 'dart:convert';

class Todo {
  final int id;
  final String title;
  final String createTime;
  final int isDone;
  Todo({
    required this.id,
    required this.title,
    required this.createTime,
    required this.isDone,
  });

  Todo copyWith({
    int? id,
    String? title,
    String? createTime,
    int? isDone,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      createTime: createTime ?? this.createTime,
      isDone: isDone ?? this.isDone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'create_time': createTime,
      'is_done': isDone,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as int,
      title: map['title'] as String,
      createTime: map['create_time'] as String,
      isDone: map['is_done'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Todo.fromJson(String source) =>
      Todo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Todo(id: $id, title: $title, create_time: $createTime, is_done: $isDone)';
  }

  @override
  bool operator ==(covariant Todo other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.createTime == createTime &&
        other.isDone == isDone;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ createTime.hashCode ^ isDone.hashCode;
  }
}
