import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/shared/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/repository/todo_repo_impl.dart';
import '../entities/todo_entity.dart';

class TodoGetUseCase implements UseCase<List<TodoEntity>, GetTodoParams> {
  final todoRepo = TodoRepositoryImpl();

  @override
  Future<Either<Failure, List<TodoEntity>>> call(GetTodoParams params) async {
    return await todoRepo.getTodoFromDataSource(params.limit);
  }
}

class GetTodoParams extends Equatable {
  final int limit;
  GetTodoParams({required this.limit});

  @override
  // TODO: implement props
  List<Object?> get props => [limit];
}
