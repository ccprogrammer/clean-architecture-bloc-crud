import 'todo_entity.dart';

enum TodosViewFilter {
  all('All'),
  activeOnly('Active'),
  completedOnly('Completed');

  final String text;
  const TodosViewFilter(this.text);
}

extension TodosViewFilterX on TodosViewFilter {
  bool _filter(TodoEntity todo) {
    switch (this) {
      case TodosViewFilter.all:
        return true;
      case TodosViewFilter.activeOnly:
        return !todo.isCompleted;
      case TodosViewFilter.completedOnly:
        return todo.isCompleted;
    }
  }

  Iterable<TodoEntity> list(Iterable<TodoEntity> todos) {
    return todos.where(_filter);
  }
}
