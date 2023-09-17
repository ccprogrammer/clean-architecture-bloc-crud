part of 'todo_bloc.dart';

@immutable
class TodoState extends Equatable {
  TodoState({
    this.status = DataStates.initial,
    this.message = '',
    this.todos = const [],
    this.filter = TodosViewFilter.all,
  });

  final DataStates status;
  final String message;
  final List<TodoEntity> todos;
  final TodosViewFilter filter;

  Iterable<TodoEntity> get filteredTodos => filter.list(todos);

  TodoState copyWith({
    DataStates? status,
    String? message,
    List<TodoEntity>? todos,
    TodosViewFilter? filter,
  }) {
    return TodoState(
      status: status ?? this.status,
      message: message ?? this.message,
      todos: todos ?? this.todos,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        filter,
        todos,
      ];
}
