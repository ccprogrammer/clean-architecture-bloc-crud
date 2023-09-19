import 'package:crud_bloc/core/errors/exceptions.dart';
import 'package:crud_bloc/features/todo/data/models/todo_model.dart';
import 'package:dartz/dartz.dart';

import 'package:crud_bloc/core/errors/failures.dart';

import '../../domain/repository/todo_repo.dart';
import '../datasources/todo_remote_datasource.dart';

class TodoRepositoryImpl implements TodoRepository {
  TodoRepositoryImpl({required this.todoRemoteDatasource});

  final TodoRemoteDataSource todoRemoteDatasource;

  @override
  Future<Either<Failure, List<TodoModel>>> getTodoFromDataSource(
      int limit) async {
    try {
      final data = await todoRemoteDatasource.getRandomTodoFromApi();
      final result = data.take(limit).toList();

      return right(result);
    } on ServerException catch (_) {
      return left(ServerFailure());
    } catch (e) {
      return left(GeneralFailure());
    }
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
