part of 'todo_bloc.dart';

@immutable
abstract class TodoEvent {}

class TodoEventAdd extends TodoEvent {
  final TodoEntity todo;
  TodoEventAdd({required this.todo});
}

class TodoEventDelete extends TodoEvent {
  final TodoEntity todo;
  TodoEventDelete({required this.todo});
}

class TodoEventIsCompleted extends TodoEvent {
  final int index;
  final bool isCompleted;

  TodoEventIsCompleted({
    required this.index,
    required this.isCompleted,
  });
}

class TodoEventFilter extends TodoEvent {
  final TodosViewFilter filter;

  TodoEventFilter({
    required this.filter,
  });
}
