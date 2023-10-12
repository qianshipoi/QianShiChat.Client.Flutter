import 'dart:convert';

class GlobalResponse {
  int statusCode;
  dynamic data;
  bool succeeded;
  dynamic errors;
  int timestamp;
  GlobalResponse({
    required this.statusCode,
    required this.data,
    required this.succeeded,
    required this.errors,
    required this.timestamp,
  });

  GlobalResponse copyWith({
    int? statusCode,
    dynamic data,
    bool? succeeded,
    dynamic errors,
    int? timestamp,
  }) {
    return GlobalResponse(
      statusCode: statusCode ?? this.statusCode,
      data: data ?? this.data,
      succeeded: succeeded ?? this.succeeded,
      errors: errors ?? this.errors,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'statusCode': statusCode,
      'data': data,
      'succeeded': succeeded,
      'errors': errors,
      'timestamp': timestamp,
    };
  }

  factory GlobalResponse.fromMap(Map<String, dynamic> map) {
    return GlobalResponse(
      statusCode: map['statusCode'] as int,
      data: map['data'] as dynamic,
      succeeded: map['succeeded'] as bool,
      errors: map['errors'] as dynamic,
      timestamp: map['timestamp'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory GlobalResponse.fromJson(String source) =>
      GlobalResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GlobalResponse(statusCode: $statusCode, data: $data, succeeded: $succeeded, errors: $errors, timestamp: $timestamp)';
  }

  @override
  bool operator ==(covariant GlobalResponse other) {
    if (identical(this, other)) return true;

    return other.statusCode == statusCode &&
        other.data == data &&
        other.succeeded == succeeded &&
        other.errors == errors &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return statusCode.hashCode ^
        data.hashCode ^
        succeeded.hashCode ^
        errors.hashCode ^
        timestamp.hashCode;
  }
}
