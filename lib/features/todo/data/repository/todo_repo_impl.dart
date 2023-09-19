import 'package:crud_bloc/features/todo/data/models/todo_model.dart';
import 'package:dartz/dartz.dart';

import 'package:crud_bloc/core/errors/failures.dart';

import '../../domain/repository/todo_repo.dart';
import '../datasources/todo_remote_datasource.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource todoRemoteDatasource = TodoRemoteDataSource();

  @override
  Future<Either<Failure, List<TodoModel>>> getTodoFromDataSource(int limit) async {
    final result = await todoRemoteDatasource.getRandomTodoFromApi();
    final reducedResult = result.take(limit).toList();

    return right(reducedResult);
  }

  @override
  Future<Either<Failure, void>> addTodoToDataSource() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteTodoToDataSource() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> updateTodoToDataSource() {
    throw UnimplementedError();
  }
}
