import 'dart:convert';

class TodoEntity {
  final String id;
  final String title;
  final String subtitle;
  final bool isCompleted;

  TodoEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
  });

  TodoEntity copyWith({
    String? id,
    String? title,
    String? subtitle,
    bool? isCompleted,
  }) {
    return TodoEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'isCompleted': isCompleted,
    };
  }

  factory TodoEntity.fromMap(Map<String, dynamic> map) {
    return TodoEntity(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      isCompleted: map['isCompleted'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoEntity.fromJson(String source) =>
      TodoEntity.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TodoEntity(id: $id, title: $title, subtitle: $subtitle, isCompleted: $isCompleted)';
  }
}
