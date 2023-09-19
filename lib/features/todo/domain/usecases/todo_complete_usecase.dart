import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/todo_entity.dart';
import '../repository/todo_repo.dart';

class TodoCompleteUseCase
    extends UseCase<List<TodoEntity>, TodoParamsComplete> {
  TodoCompleteUseCase({required this.repository});

  final TodoRepository repository;

  @override
  Future<Either<Failure, List<TodoEntity>>> call(
      TodoParamsComplete params) async {
    final _todos = [...params.todos];

    final newTodo = _todos
        .elementAt(params.index)
        .copyWith(isCompleted: params.isCompleted);

    _todos[params.index] = newTodo;

    return right(_todos);
  }
}

class TodoParamsComplete extends Equatable {
  final List<TodoEntity> todos;
  final int index;
  final bool isCompleted;

  TodoParamsComplete(
      {required this.index, required this.isCompleted, required this.todos});

  @override
  List<Object?> get props => [todos, index, isCompleted];
}
