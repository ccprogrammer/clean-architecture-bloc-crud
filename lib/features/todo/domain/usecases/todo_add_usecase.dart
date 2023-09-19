import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/todo_entity.dart';

class TodoAddUseCase extends UseCase<List<TodoEntity>, TodoParamsAdd> {
  @override
  Future<Either<Failure, List<TodoEntity>>> call(TodoParamsAdd params) async {
    final _todos = [...params.todos, params.todo];
    await Future.delayed(Duration(milliseconds: 500));
    return right(_todos);
  }
}

class TodoParamsAdd extends Equatable {
  final List<TodoEntity> todos;
  final TodoEntity todo;
  TodoParamsAdd({
    required this.todos,
    required this.todo,
  });

  @override
  List<Object?> get props => [todos, todo];
}
