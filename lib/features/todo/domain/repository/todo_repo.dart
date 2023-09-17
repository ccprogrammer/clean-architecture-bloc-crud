import 'package:crud_bloc/core/shared/failures.dart';
import 'package:crud_bloc/features/todo/domain/entities/todo_entity.dart';
import 'package:dartz/dartz.dart';

abstract class TodoRepository {
  Future<Either<Failure, List<TodoEntity>>> getTodoFromDataSource();
}
