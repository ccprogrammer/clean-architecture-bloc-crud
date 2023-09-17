import 'package:equatable/equatable.dart';

class TodoEntity extends Equatable {
  final int id;
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
    int? id,
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

  List<Object?> get props => [
        id,
        title,
        subtitle,
        isCompleted,
      ];
}
