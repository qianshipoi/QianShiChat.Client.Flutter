import 'dart:convert';

class PagedList {
  dynamic items;
  int total;
  int currentPage;
  int currentSize;
  bool hasPrev;
  bool hasNext;
  PagedList({
    required this.items,
    required this.total,
    required this.currentPage,
    required this.currentSize,
    required this.hasPrev,
    required this.hasNext,
  });

  PagedList copyWith({
    dynamic items,
    int? total,
    int? currentPage,
    int? currentSize,
    bool? hasPrev,
    bool? hasNext,
  }) {
    return PagedList(
      items: items ?? this.items,
      total: total ?? this.total,
      currentPage: currentPage ?? this.currentPage,
      currentSize: currentSize ?? this.currentSize,
      hasPrev: hasPrev ?? this.hasPrev,
      hasNext: hasNext ?? this.hasNext,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'items': items,
      'total': total,
      'currentPage': currentPage,
      'currentSize': currentSize,
      'hasPrev': hasPrev,
      'hasNext': hasNext,
    };
  }

  factory PagedList.fromMap(Map<String, dynamic> map) {
    return PagedList(
      items: map['items'] as dynamic,
      total: map['total'] as int,
      currentPage: map['currentPage'] as int,
      currentSize: map['currentSize'] as int,
      hasPrev: map['hasPrev'] as bool,
      hasNext: map['hasNext'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory PagedList.fromJson(String source) =>
      PagedList.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PagedList(items: $items, total: $total, currentPage: $currentPage, currentSize: $currentSize, hasPrev: $hasPrev, hasNext: $hasNext)';
  }

  @override
  bool operator ==(covariant PagedList other) {
    if (identical(this, other)) return true;

    return other.items == items &&
        other.total == total &&
        other.currentPage == currentPage &&
        other.currentSize == currentSize &&
        other.hasPrev == hasPrev &&
        other.hasNext == hasNext;
  }

  @override
  int get hashCode {
    return items.hashCode ^
        total.hashCode ^
        currentPage.hashCode ^
        currentSize.hashCode ^
        hasPrev.hashCode ^
        hasNext.hashCode;
  }
}
