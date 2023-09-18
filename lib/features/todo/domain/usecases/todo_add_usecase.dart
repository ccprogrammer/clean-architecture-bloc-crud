import 'package:dartz/dartz.dart';

import '../../../../core/shared/failures.dart';
import '../../data/repository/todo_repo_impl.dart';
import '../entities/todo_entity.dart';

class TodoAddUseCase {
  final todoRepo = TodoRepositoryImpl();

  Future<Either<Failure, List<TodoEntity>>> addTodo(
    List<TodoEntity> todos,
    TodoEntity todo,
  ) async {
    final _todos = [...todos, todo];
    await Future.delayed(Duration(milliseconds: 500));
    return right(_todos);
  }
}
