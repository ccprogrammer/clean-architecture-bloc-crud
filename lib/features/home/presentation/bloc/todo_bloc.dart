import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../enums/data_states.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/entities/todos_view_filter.dart';
import '../../domain/usecases/todo_usecases.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoState(todos: const [])) {
    on<TodoEventAdd>(_todoEventAdd);

    on<TodoEventDelete>(_todoEventDelete);

    on<TodoEventIsCompleted>(_todoEventIsCompleted);

    on<TodoEventFilter>(_todoEventFilter);
  }

  final todoUseCases = TodoUseCases();

  void _todoEventAdd(TodoEventAdd event, Emitter emit) async {
    emit(
      state.copyWith(status: DataStates.loading),
    );

    final _todos = await todoUseCases.addTodo(state.todos, event.todo);

    emit(
      state.copyWith(
        todos: _todos,
        status: DataStates.success,
      ),
    );
  }

  void _todoEventDelete(TodoEventDelete event, Emitter emit) async {
    final _todos = await todoUseCases.deleteTodo(state.todos, event.todo);

    emit(
      state.copyWith(todos: _todos),
    );
  }

  void _todoEventIsCompleted(TodoEventIsCompleted event, Emitter emit) async {
    final _todos = await todoUseCases.completeTodo(
        state.todos, event.index, event.isCompleted);

    emit(
      state.copyWith(
        todos: _todos,
      ),
    );
  }

  void _todoEventFilter(TodoEventFilter event, Emitter emit) {
    emit(
      state.copyWith(filter: event.filter),
    );
  }
}
