import 'package:crud_bloc/features/todo/domain/entities/todo_entity.dart';
import 'package:equatable/equatable.dart';

class TodoModel extends TodoEntity with EquatableMixin {
  TodoModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'isCompleted': isCompleted,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      subtitle: map['title'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  @override
  String toString() {
    return 'TodoModel(id: $id, title: $title, subtitle: $subtitle, isCompleted: $isCompleted)';
  }
}
