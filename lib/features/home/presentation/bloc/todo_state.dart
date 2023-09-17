part of 'todo_bloc.dart';

@immutable
class TodoState extends Equatable {
  TodoState({
    this.status = DataStates.initial,
    this.filter = TodosViewFilter.all,
    this.todos = const [],
  });

  final DataStates status;
  final List<TodoEntity> todos;
  final TodosViewFilter filter;

  Iterable<TodoEntity> get filteredTodos => filter.list(todos);

  TodoState copyWith({
    DataStates? status,
    List<TodoEntity>? todos,
    TodosViewFilter? filter,
  }) {
    return TodoState(
      status: status ?? this.status,
      todos: todos ?? this.todos,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [
        status,
        filter,
        todos,
      ];
}
