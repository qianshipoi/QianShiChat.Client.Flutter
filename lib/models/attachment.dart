// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

class Attachment {
  int id;
  String name;
  String rawPath;
  String? previewPath;
  String hash;
  String contentType;
  int size;
  int? progress;
  Attachment({
    required this.id,
    required this.name,
    required this.rawPath,
    required this.previewPath,
    required this.hash,
    required this.contentType,
    required this.size,
    this.progress,
  });

  Attachment copyWith({
    int? id,
    String? name,
    String? rawPath,
    String? previewPath,
    String? hash,
    String? contentType,
    int? size,
    int? progress,
  }) {
    return Attachment(
      id: id ?? this.id,
      name: name ?? this.name,
      rawPath: rawPath ?? this.rawPath,
      previewPath: previewPath ?? this.previewPath,
      hash: hash ?? this.hash,
      contentType: contentType ?? this.contentType,
      size: size ?? this.size,
      progress: progress ?? this.progress,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'rawPath': rawPath,
      'previewPath': previewPath,
      'hash': hash,
      'contentType': contentType,
      'size': size,
      'progress': progress,
    };
  }

  factory Attachment.fromMap(Map<String, dynamic> map) {
    return Attachment(
      id: map['id'] as int,
      name: map['name'] as String,
      rawPath: map['rawPath'] as String,
      previewPath: map['previewPath'] as String?,
      hash: map['hash'] as String,
      contentType: map['contentType'] as String,
      size: map['size'] as int,
      progress: map['progress'] != null ? map['progress'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Attachment.fromJson(String source) =>
      Attachment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Attachment(id: $id, name: $name, rawPath: $rawPath, previewPath: $previewPath, hash: $hash, contentType: $contentType, size: $size, progress: $progress)';
  }

  @override
  bool operator ==(covariant Attachment other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.rawPath == rawPath &&
        other.previewPath == previewPath &&
        other.hash == hash &&
        other.contentType == contentType &&
        other.size == size &&
        other.progress == progress;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        rawPath.hashCode ^
        previewPath.hashCode ^
        hash.hashCode ^
        contentType.hashCode ^
        size.hashCode ^
        progress.hashCode;
  }
}
