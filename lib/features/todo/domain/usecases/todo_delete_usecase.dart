import 'package:crud_bloc/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/todo_entity.dart';
import '../repository/todo_repo.dart';

class TodoDeleteUseCase extends UseCase<List<TodoEntity>, TodoParamsDelete> {
  TodoDeleteUseCase({required this.repository});

  final TodoRepository repository;
  @override
  Future<Either<Failure, List<TodoEntity>>> call(
      TodoParamsDelete params) async {
    final _todos = [...params.todos];

    _todos.removeWhere((TodoEntity todo) => todo.id == todo.id);

    return right(_todos);
  }
}

class TodoParamsDelete extends Equatable {
  final List<TodoEntity> todos;
  final TodoEntity todo;

  TodoParamsDelete({required this.todos, required this.todo});

  @override
  List<Object?> get props => [todos, todo];
}
