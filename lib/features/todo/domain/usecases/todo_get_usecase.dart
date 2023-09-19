import 'package:crud_bloc/features/todo/domain/repository/todo_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/todo_entity.dart';

class TodoGetUseCase extends UseCase<List<TodoEntity>, TodoParamsGet> {
  TodoGetUseCase({required this.repository});

  final TodoRepository repository;

  @override
  Future<Either<Failure, List<TodoEntity>>> call(TodoParamsGet params) async {
    return await repository.getTodoFromDataSource(params.limit);
  }
}

class TodoParamsGet extends Equatable {
  final int limit;
  TodoParamsGet({required this.limit});

  @override
  List<Object?> get props => [limit];
}
