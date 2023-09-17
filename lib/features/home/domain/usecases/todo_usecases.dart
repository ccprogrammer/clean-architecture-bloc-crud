import 'package:crud_bloc/features/home/domain/entities/todo_entity.dart';

class TodoUseCases {
  Future<List<TodoEntity>> addTodo(
    List<TodoEntity> todos,
    TodoEntity todo,
  ) async {
    final _todos = [...todos, todo];
    await Future.delayed(Duration(milliseconds: 500));
    return _todos;
  }

  Future<List<TodoEntity>> deleteTodo(
    List<TodoEntity> todos,
    TodoEntity todo,
  ) async {
    final _todos = [...todos];

    _todos.removeWhere((TodoEntity todo) => todo.id == todo.id);

    return _todos;
  }

  Future<List<TodoEntity>> completeTodo(
    List<TodoEntity> todos,
    int index,
    bool isCompleted,
  ) async {
    final _todos = [...todos];

    final newTodo = _todos.elementAt(index).copyWith(isCompleted: isCompleted);

    _todos[index] = newTodo;

    return _todos;
  }
}
