import 'package:dartz/dartz.dart';

import '../../../../core/shared/failures.dart';
import '../../data/repository/todo_repo_impl.dart';
import '../entities/todo_entity.dart';

class TodoDeleteUseCase {
  final todoRepo = TodoRepositoryImpl();

  Future<Either<Failure, List<TodoEntity>>> deleteTodo(
    List<TodoEntity> todos,
    TodoEntity todo,
  ) async {
    final _todos = [...todos];

    _todos.removeWhere((TodoEntity todo) => todo.id == todo.id);

    return right(_todos);
  }
  
}
