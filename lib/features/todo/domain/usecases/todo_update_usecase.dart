import 'package:dartz/dartz.dart';

import '../../../../core/shared/failures.dart';
import '../entities/todo_entity.dart';

class TodoUpdateUseCase {
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
  }
}
