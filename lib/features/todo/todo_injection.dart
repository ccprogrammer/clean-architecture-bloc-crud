import 'package:crud_bloc/features/todo/presentation/bloc/todo_bloc.dart';

import '../../core/injection/injection.dart';
import 'data/datasources/todo_remote_datasource.dart';
import 'data/repository/todo_repo_impl.dart';
import 'domain/repository/todo_repo.dart';
import 'domain/usecases/todo_add_usecase.dart';
import 'domain/usecases/todo_complete_usecase.dart';
import 'domain/usecases/todo_delete_usecase.dart';
import 'domain/usecases/todo_get_usecase.dart';
import 'domain/usecases/todo_update_usecase.dart';

class TodoInjection {
  TodoInjection._();

  static Future<void> init() async {
    // Datasource
    sl.registerFactory<TodoRemoteDataSource>(
        () => TodoRemoteDataSourceImpl(client: sl()));

    // Repository
    sl.registerFactory<TodoRepository>(
        () => TodoRepositoryImpl(todoRemoteDatasource: sl()));

    // Usecase
    sl.registerFactory(() => TodoGetUseCase(repository: sl()));
    sl.registerFactory(() => TodoAddUseCase(repository: sl()));
    sl.registerFactory(() => TodoDeleteUseCase(repository: sl()));
    sl.registerFactory(() => TodoUpdateUseCase(repository: sl()));
    sl.registerFactory(() => TodoCompleteUseCase(repository: sl()));

    // Bloc
    sl.registerFactory(
      () => TodoBloc(
        addUseCase: sl(),
        updateUseCase: sl(),
        deleteUseCase: sl(),
        completeUseCase: sl(),
        getUseCase: sl(),
      ),
    );
  }
}
