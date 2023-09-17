import 'package:crud_bloc/features/todo/data/models/todo_model.dart';
import 'package:dartz/dartz.dart';


import 'package:crud_bloc/core/shared/failures.dart';

import '../../domain/repository/todo_repo.dart';
import '../datasources/todo_remote_datasource.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource todoRemoteDatasource = TodoRemoteDataSource();

  @override
  Future<Either<Failure, List<TodoModel>>> getTodoFromDataSource() async {
    final result = await todoRemoteDatasource.getRandomTodoFromApi();
    final reducedResult = result.take(5).toList();

    return right(reducedResult);
  }
}
