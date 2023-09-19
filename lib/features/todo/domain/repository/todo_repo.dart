import 'package:crud_bloc/core/errors/failures.dart';
import 'package:crud_bloc/features/todo/domain/entities/todo_entity.dart';
import 'package:dartz/dartz.dart';

abstract class TodoRepository {
  Future<Either<Failure, List<TodoEntity>>> getTodoFromDataSource(int limit);

  Future<Either<Failure, void>> addTodoToDataSource();

  Future<Either<Failure, void>> deleteTodoToDataSource();

  Future<Either<Failure, void>> updateTodoToDataSource();
}
