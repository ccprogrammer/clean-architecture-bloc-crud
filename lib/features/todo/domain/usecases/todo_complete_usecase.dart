import 'package:dartz/dartz.dart';

import '../../../../core/shared/failures.dart';
import '../entities/todo_entity.dart';

class TodoCompleteUseCase {
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
