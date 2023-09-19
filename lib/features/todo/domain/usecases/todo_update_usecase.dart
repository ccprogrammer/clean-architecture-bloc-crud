import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/todo_entity.dart';

class TodoUpdateUseCase extends UseCase<List<TodoEntity>, TodoParamsUpdate> {
  @override
  Future<Either<Failure, List<TodoEntity>>> call(
      TodoParamsUpdate params) async {
    final _todos = [...params.todos];
    final newTodo = _todos
        .elementAt(params.index)
        .copyWith(title: params.title, subtitle: params.subtitle);

    _todos[params.index] = newTodo;
    await Future.delayed(Duration(milliseconds: 500));
    return right(_todos);
  }
}

class TodoParamsUpdate extends Equatable {
  final List<TodoEntity> todos;
  final int index;
  final String title;
  final String subtitle;

  TodoParamsUpdate(
      {required this.todos,
      required this.index,
      required this.title,
      required this.subtitle});

  @override
  List<Object?> get props => [todos, index, title, subtitle];
}
