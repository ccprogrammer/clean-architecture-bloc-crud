import 'package:crud_bloc/features/home/domain/entities/todo_entity.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/shared/failures.dart';

class TodoUseCases {
  Future<Either<Failure, List<TodoEntity>>> addTodo(
    List<TodoEntity> todos,
    TodoEntity todo,
  ) async {
    final _todos = [...todos, todo];
    await Future.delayed(Duration(milliseconds: 500));
    return right(_todos);
    // return left(FailureGeneral());
  }

  Future<Either<Failure, List<TodoEntity>>> updateTodo(
    List<TodoEntity> todos,
    int index,
    String title,
    String subtitle,
  ) async {
    final _todos = [...todos];
    final newTodo =
        _todos.elementAt(index).copyWith(title: title, subtitle: subtitle);

    _todos[index] = newTodo;
    await Future.delayed(Duration(milliseconds: 500));
    return right(_todos);
    // return left(FailureGeneral());
  }

  Future<Either<Failure, List<TodoEntity>>> deleteTodo(
    List<TodoEntity> todos,
    TodoEntity todo,
  ) async {
    final _todos = [...todos];

    _todos.removeWhere((TodoEntity todo) => todo.id == todo.id);

    return right(_todos);
  }

  Future<Either<Failure, List<TodoEntity>>> completeTodo(
    List<TodoEntity> todos,
    int index,
    bool isCompleted,
  ) async {
    final _todos = [...todos];

    final newTodo = _todos.elementAt(index).copyWith(isCompleted: isCompleted);

    _todos[index] = newTodo;

    return right(_todos);
  }
}
