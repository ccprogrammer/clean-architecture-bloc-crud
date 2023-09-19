import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/repository/todo_repo_impl.dart';
import '../entities/todo_entity.dart';

class TodoGetUseCase extends UseCase<List<TodoEntity>, TodoParamsGet> {
  final todoRepo = TodoRepositoryImpl();

  @override
  Future<Either<Failure, List<TodoEntity>>> call(TodoParamsGet params) async {
    return await todoRepo.getTodoFromDataSource(params.limit);
  }
}

class TodoParamsGet extends Equatable {
  final int limit;
  TodoParamsGet({required this.limit});

  @override
  List<Object?> get props => [limit];
}
