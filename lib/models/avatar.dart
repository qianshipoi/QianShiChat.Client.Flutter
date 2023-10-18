import 'dart:convert';

class Avatar {
  int id;
  String path;
  int size;
  int createTime;
  Avatar({
    required this.id,
    required this.path,
    required this.size,
    required this.createTime,
  });

  Avatar copyWith({
    int? id,
    String? path,
    int? size,
    int? createTime,
  }) {
    return Avatar(
      id: id ?? this.id,
      path: path ?? this.path,
      size: size ?? this.size,
      createTime: createTime ?? this.createTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'path': path,
      'size': size,
      'createTime': createTime,
    };
  }

  factory Avatar.fromMap(Map<String, dynamic> map) {
    return Avatar(
      id: map['id'] as int,
      path: map['path'] as String,
      size: map['size'] as int,
      createTime: map['createTime'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Avatar.fromJson(String source) =>
      Avatar.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Avatar(id: $id, path: $path, size: $size, createTime: $createTime)';
  }

  @override
  bool operator ==(covariant Avatar other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.path == path &&
        other.size == size &&
        other.createTime == createTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^ path.hashCode ^ size.hashCode ^ createTime.hashCode;
  }
}
