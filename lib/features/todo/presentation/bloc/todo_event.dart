part of 'todo_bloc.dart';

@immutable
abstract class TodoEvent {}

class TodoEventGet extends TodoEvent {
  final int limit;
  TodoEventGet({required this.limit});
}

class TodoEventAdd extends TodoEvent {
  final TodoEntity todo;
  TodoEventAdd({required this.todo});
}

class TodoEventUpdate extends TodoEvent {
  final int index;
  final String title;
  final String subtitle;
  TodoEventUpdate({
    required this.index,
    required this.title,
    required this.subtitle,
  });
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
