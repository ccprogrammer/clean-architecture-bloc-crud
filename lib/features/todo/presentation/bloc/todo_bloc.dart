import 'package:crud_bloc/core/shared/failures.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../enums/data_states.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/entities/todos_view_filter.dart';
import '../../domain/usecases/todo_add_usecase.dart';
import '../../domain/usecases/todo_complete_usecase.dart';
import '../../domain/usecases/todo_delete_usecase.dart';
import '../../domain/usecases/todo_get_usecase.dart';
import '../../domain/usecases/todo_update_usecase.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoState()) {
    on<TodoEventGet>(_todoEventGet);

    on<TodoEventAdd>(_todoEventAdd);

    on<TodoEventUpdate>(_todoEventUpdate);

    on<TodoEventDelete>(_todoEventDelete);

    on<TodoEventIsCompleted>(_todoEventIsCompleted);

    on<TodoEventFilter>(_todoEventFilter);
  }

  final getUseCase = TodoGetUseCase();
  final addUseCase = TodoAddUseCase();
  final updateUseCase = TodoUpdateUseCase();
  final deleteUseCase = TodoDeleteUseCase();
  final completeUseCase = TodoCompleteUseCase();

  void _todoEventGet(TodoEventGet event, Emitter emit) async {
    emit(state.copyWith(status: DataStates.loading));

    final _todos = await getUseCase.call(GetTodoParams(limit: event.limit));

    _todos.fold(
      (failure) {
        emit(
          state.copyWith(
            status: DataStates.failure,
            message: _mapFailureToMessage(failure),
          ),
        );
      },
      (todos) => emit(
        state.copyWith(
          todos: [...state.todos, ...todos],
          message: 'Getting new todos',
          status: DataStates.success,
        ),
      ),
    );
  }

  void _todoEventAdd(TodoEventAdd event, Emitter emit) async {
    emit(
      state.copyWith(status: DataStates.loading),
    );

    final _todos = await addUseCase.addTodo(state.todos, event.todo);

    _todos.fold(
      (failure) {
        emit(
          state.copyWith(
            status: DataStates.failure,
            message: _mapFailureToMessage(failure),
          ),
        );
      },
      (todos) => emit(
        state.copyWith(
          todos: todos,
          message: 'Todo added',
          status: DataStates.success,
        ),
      ),
    );
  }

  void _todoEventUpdate(TodoEventUpdate event, Emitter emit) async {
    final _todos = await updateUseCase.updateTodo(
      state.todos,
      event.index,
      event.title,
      event.subtitle,
    );

    _todos.fold(
      (failure) {
        emit(
          state.copyWith(
            status: DataStates.failure,
            message: _mapFailureToMessage(failure),
          ),
        );
      },
      (todos) => emit(
        state.copyWith(
          todos: todos,
          message: 'Todo updated',
          status: DataStates.success,
        ),
      ),
    );
  }

  void _todoEventDelete(TodoEventDelete event, Emitter emit) async {
    final _todos = await deleteUseCase.deleteTodo(state.todos, event.todo);

    _todos.fold(
      (failure) {
        emit(
          state.copyWith(
            status: DataStates.failure,
            message: _mapFailureToMessage(failure),
          ),
        );
      },
      (todos) => emit(
        state.copyWith(
          todos: todos,
          message: 'Delete todo',
          status: DataStates.success,
        ),
      ),
    );
  }

  void _todoEventIsCompleted(TodoEventIsCompleted event, Emitter emit) async {
    final _todos = await completeUseCase.completeTodo(
        state.todos, event.index, event.isCompleted);

    _todos.fold(
      (failure) {
        emit(
          state.copyWith(
            status: DataStates.failure,
            message: _mapFailureToMessage(failure),
          ),
        );
      },
      (todos) => emit(
        state.copyWith(
          todos: todos,
          message: 'Complete todo',
          status: DataStates.success,
        ),
      ),
    );
  }

  void _todoEventFilter(TodoEventFilter event, Emitter emit) {
    emit(
      state.copyWith(
        filter: event.filter,
        message: 'Change view to ${event.filter.text}',
      ),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case FailureServer:
        return 'Something went wrong in the server, please try again';
      case FailureCache:
        return 'Something went wrong in the storage, please try again';
      default:
        return 'Something went wrong, please try again';
    }
  }
}
